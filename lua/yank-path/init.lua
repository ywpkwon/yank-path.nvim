-- lua/yank-path/init.lua
local M = {}

local config = {
  prompt = "Yank which path?",
  default_mapping = true,
  use_oil = true,  -- built-in Oil integration enabled by default
}

-- List of user-provided path providers
local providers = {}

--- Register a path provider.
--- A provider is a function that returns a file path (string) or nil.
function M.register_provider(fn)
  table.insert(providers, fn)
end

local function escape_pattern(text)
  return text:gsub("([^%w])", "%%%1")
end

-- Built-in Oil provider (optional, guarded by config + pcall)
local function try_oil_path()
  if not config.use_oil then
    return nil
  end

  local ok, oil = pcall(require, "oil")
  if not ok then
    return nil
  end

  local dir = oil.get_current_dir()
  if not dir then
    return nil
  end

  local entry = oil.get_cursor_entry()
  if not entry or not entry.name then
    return nil
  end

  -- If you don't want directories, skip them
  if entry.type == "directory" then
    return nil
  end

  if not dir:match("/$") then
    dir = dir .. "/"
  end

  return dir .. entry.name
end

local function get_current_file()
  -- 1) Built-in Oil support
  local oil_path = try_oil_path()
  if oil_path then
    return oil_path
  end

  -- 2) Try user-registered providers (Snacks, etc.)
  for _, fn in ipairs(providers) do
    local ok, path = pcall(fn)
    if ok and type(path) == "string" and path ~= "" then
      return path
    end
  end

  -- 3) Fallback: normal file buffer
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == nil or bufname == "" then
    return nil
  end
  return bufname
end

function M.yank_file_path()
  local file = get_current_file()
  if not file then
    vim.notify("No file name for current buffer / entry", vim.log.levels.WARN)
    return
  end

  local fullpath   = file
  local filename   = vim.fn.fnamemodify(file, ":t")
  local basename   = vim.fn.fnamemodify(file, ":t:r")
  local extension  = vim.fn.fnamemodify(file, ":e")
  local home       = vim.loop.os_homedir()
  local uri        = vim.uri_from_fname(file)

  local path_cwd = vim.fn.fnamemodify(file, ":.")
  local path_home
  if home and home ~= "" then
    path_home = fullpath:gsub("^" .. escape_pattern(home), "~")
  else
    path_home = fullpath
  end

  local entries = {
    { label = "BASENAME",    value = basename },
    { label = "EXTENSION",   value = extension },
    { label = "FILENAME",    value = filename },
    { label = "PATH",        value = fullpath },
    { label = "PATH (CWD)",  value = path_cwd },
    { label = "PATH (HOME)", value = path_home },
    { label = "URI",         value = uri },
  }

  vim.ui.select(
    entries,
    {
      prompt = config.prompt,
      format_item = function(item)
        return item.label .. ": " .. item.value
      end,
    },
    function(choice)
      if not choice then return end
      vim.fn.setreg("+", choice.value)
      vim.fn.setreg('"', choice.value)
      vim.notify(
        ("Yanked %s: %s"):format(choice.label, choice.value),
        vim.log.levels.INFO
      )
    end
  )
end

M.setup = function(opts)
  opts = opts or {}

  if opts.prompt ~= nil then
    config.prompt = opts.prompt
  end

  if opts.default_mapping ~= nil then
    config.default_mapping = opts.default_mapping
  end

  if opts.use_oil ~= nil then
    config.use_oil = opts.use_oil
  end

  -- Only create mapping if enabled
  if config.default_mapping then
    vim.keymap.set(
      "n",
      "Y",
      "<cmd>YankPath<CR>",
      { desc = "Yank file path variant", silent = true }
    )
  end
end

return M
