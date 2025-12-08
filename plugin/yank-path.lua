-- UI picker
vim.api.nvim_create_user_command("YankPath", function()
  require("yank-path").yank_file_path()
end, { desc = "Yank a variant of the current file path" })

-- Direct, no-UI commands
vim.api.nvim_create_user_command("YankPathBase", function()
  require("yank-path").yank_basename()
end, { desc = "Yank file basename (no extension)" })

vim.api.nvim_create_user_command("YankPathExtension", function()
  require("yank-path").yank_extension()
end, { desc = "Yank file extension" })

vim.api.nvim_create_user_command("YankPathFilename", function()
  require("yank-path").yank_filename()
end, { desc = "Yank file name (with extension)" })

vim.api.nvim_create_user_command("YankPathFull", function()
  require("yank-path").yank_path()
end, { desc = "Yank full file path" })

vim.api.nvim_create_user_command("YankPathCwd", function()
  require("yank-path").yank_path_cwd()
end, { desc = "Yank path relative to CWD" })

vim.api.nvim_create_user_command("YankPathHome", function()
  require("yank-path").yank_path_home()
end, { desc = "Yank path with ~ for $HOME" })

vim.api.nvim_create_user_command("YankPathUri", function()
  require("yank-path").yank_uri()
end, { desc = "Yank file URI (file://...)" })
