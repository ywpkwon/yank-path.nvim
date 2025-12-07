# 🧩 yank-path.nvim
Minimal plugin to **copy (yank) different variants of the current file path** - inspired by Neo-tree's `Y` menu, but without needing Neo-tree.

https://github.com/user-attachments/assets/2d119010-05da-4e6a-986d-545161e715f4

This plugin gives you a simple picker (using `vim.ui.select`, so telescope/dressing/etc. improve it automatically) to copy:

```
1. BASENAME: tmux-keybindings
2. EXTENSION: conf
3. FILENAME: tmux-keybindings.conf
4. PATH: /home/paulk/dotfiles/tmux/tmux-keybindings.conf
5. PATH (CWD): tmux/tmux-keybindings.conf
6. PATH (HOME): ~/dotfiles/tmux/tmux-keybindings.conf
7. URI: file:///home/paulk/dotfiles/tmux/tmux-keybindings.conf
```

## ✨ Features

- Yank **basename**, **extension**, **filename**, **fullpath**, **cwd-relative**, **home-relative**, or **URI**
- Uses `vim.ui.select` → works great with:
  - `dressing.nvim`
  - Telescope UI select
  - fzf-lua / fzy overrides
- Writes to both:
  - `+` system clipboard
  - `"` unnamed register
- Comes with default keymap (`Y`) and `:YankPath` command
- No dependencies, tiny, pure Lua

## 📦 Installation

### lazy.nvim

```lua
{
  "ywpkwon/yank-path.nvim",
  config = function()
    require("yank_path").setup()
  end,
}
```

### packer.nvim

```lua
use {
  "ywpkwon/yank-path.nvim",
  config = function()
    require("yank_path").setup()
  end,
}
```

## 🚀 Usage

- Default keymap in normal mode: `Y`
- Command: `:YankPath`
- Programmatically: `require("yank_path").yank_file_path()`

## 🔧 Configuration

`yank-path.nvim` provides a small `setup()` function for optional settings.
By default, the plugin maps `Y`. If you prefer to define your own mapping (or no mapping at all), disable it:

```lua
require("yank_path").setup({
  default_mapping = false,
})
```

Then set your own keymap:

```lua
vim.keymap.set("n", "<leader>yp", "<cmd>YankPath<CR>", { desc = "Yank file path" })
```

## 🙏 Acknowledgements

This plugin was inspired by great ideas from the following projects:

- **[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)**  
  The `Y` yank-path popup in Neo-tree motivated this plugin's core behavior.

- **[oil.nvim](https://github.com/stevearc/oil.nvim)**  
  A fantastic filesystem UI for Neovim.  
  This plugin includes built-in compatibility to yank paths directly from Oil buffers.

Huge thanks to the authors and contributors of these projects for their amazing work.

## 📝 Note from the Author

I'm not a typical Neovim plugin developer. This plugin started as a small
personal tool to replicate path-yanking behavior I liked from Neo-tree, but
without needing the full file explorer.

I'm still very new to writing Neovim plugins, and I may not always be able to
actively expand or maintain the project. That said, I'm happy if others find it
useful, and contributions or suggestions are always welcome.

## 📜 License

MIT
