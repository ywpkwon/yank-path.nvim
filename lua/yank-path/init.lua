-- lua/yank_path/init.lua
local M = {}

local config = {
  prompt = "Yank which path?",
  default_mapping = true,
}

local function escape_pattern(text)
  return text:gsub("([^%w])", "%%%1")
end

-- Try to detect if we're in an oil.nvim buffer and get the path
local function get_oil_path_if_any()
  -- pcall to avoid error if oil.nvim isn't installed
  local ok, oil = pcall(require, "oil")
  if not ok then
    return nil
  end

  -- oil.has_file? Not needed, we can just try its APIs
  local dir = oil.get_current_dir()
  if not dir then
    return nil
  end

  local entry = oil.get_cursor_entry()
  if not entry or not entry.name then
    return nil
  end

  -- Skip directories for now
  if entry.type == "directory" then
    return nil
  end

  -- Ensure dir ends with "/" (oil usually provides it, but be safe)
  if not dir:match("/$") then
    dir = dir .. "/"
  end

  return dir .. entry.name
end

local function get_current_file()
  -- 1) If in oil, use its API
  local oil_path = get_oil_path_if_any()
  if oil_path then
    return oil_path
  end

  -- 2) Otherwise, assume normal file buffer
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
  local cwd        = vim.loop.cwd()
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
