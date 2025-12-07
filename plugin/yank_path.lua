vim.api.nvim_create_user_command("YankPath", function()
  require("yank_path").yank_file_path()
end, { desc = "Yank a variant of the current file path" })

vim.keymap.set(
  "n",
  "Y",
  "<cmd>YankPath<CR>",
  { desc = "Yank file path variant", silent = true }
)
