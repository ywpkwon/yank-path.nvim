-- Create :YankPath command (always available)
vim.api.nvim_create_user_command("YankPath", function()
  require("yank_path").yank_file_path()
end, { desc = "Yank a variant of the current file path" })

-- Setup default mapping only if enabled in config
local enabled = vim.g.yank_path_enable_default_mapping

if enabled == nil or enabled == true then
  vim.keymap.set(
    "n",
    "Y",
    "<cmd>YankPath<CR>",
    { desc = "Yank file path variant", silent = true }
  )
end
