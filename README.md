# 🧩 yank-path.nvim
Minimal plugin to **copy (yank) different variants of the current file path** — inspired by Neo-tree’s `Y` menu, but without needing Neo-tree.

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
  "paulk/yank-path.nvim",
  config = function()
    require("yank_path").setup()
  end,
}
```

### packer.nvim

```lua
use {
  "paulk/yank-path.nvim",
  config = function()
    require("yank_path").setup()
  end,
}
```

## 🚀 Usage

### Default keymap

Normal mode:

```
Y
```

### Command

```
:YankPath
```

### Programmatically

```lua
require("yank_path").yank_file_path()
```

## 🔧 Configuration (optional)

```lua
require("yank_path").setup({
  -- future: register = "+",
  -- future: mapping = "Y",
})
```

## 🗂️ File Structure

```
yank-path.nvim/
├─ lua/
│  └─ yank_path/
│     └─ init.lua
└─ plugin/
   └─ yank_path.lua
```

## 🤝 Contributing

PRs welcome.

## 📜 License

MIT
