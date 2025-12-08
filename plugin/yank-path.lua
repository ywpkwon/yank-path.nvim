vim.api.nvim_create_user_command("YankPath", function()
  require("yank-path").yank_file_path()
end, { desc = "Yank a variant of the current file path" })
