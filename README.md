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
- Comes with default keymap (`Y`) and `:YankPath` command (and more non-UI direct commands)
- No dependencies, tiny, pure Lua

## 📦 Installation

### lazy.nvim

```lua
{
  "ywpkwon/yank-path.nvim",
  config = function()
    require("yank-path").setup()
  end,
}
```

### packer.nvim

```lua
use {
  "ywpkwon/yank-path.nvim",
  config = function()
    require("yank-path").setup()
  end,
}
```

## 🚀 Usage

In addition to the main interactive picker (`:YankPath`), the plugin provides **direct, non-UI yank commands**.  
These commands yank a specific file-path variant immediately (no menu), which is perfect for users who prefer to create their own keymaps.

### 📜 Available Commands

| Command               | Description                                 |
|----------------------|---------------------------------------------|
| `:YankPath`          | UI picker (interactive selection)            |
| `:YankPathBase`      | Yank basename (filename without extension)   |
| `:YankPathExtension` | Yank file extension                          |
| `:YankPathFilename`  | Yank filename (with extension)               |
| `:YankPathFull`      | Yank full absolute path                      |
| `:YankPathCwd`       | Yank path relative to current working dir    |
| `:YankPathHome`      | Yank path with `$HOME` replaced by `~`       |
| `:YankPathUri`       | Yank file URI (`file://...`)                 |

All commands work in:

- regular file buffers  
- Oil.nvim buffers (if `use_oil = true`)  
- any custom source added via `register_provider()`  

<details>
<summary><strong>Click to expand example keymaps</strong></summary>

### 🎹 Example Keymaps (optional)

**No default keymaps are provided** for these direct commands other than the `:YankPath` (`Y`).  
Here are some example mappings you can add to your own config:

```lua
vim.keymap.set("n", "<leader>ypb", "<cmd>YankPathBase<CR>",      { desc = "Yank basename" })
vim.keymap.set("n", "<leader>ype", "<cmd>YankPathExtension<CR>", { desc = "Yank extension" })
vim.keymap.set("n", "<leader>ypf", "<cmd>YankPathFilename<CR>",  { desc = "Yank filename" })
vim.keymap.set("n", "<leader>ypp", "<cmd>YankPathFull<CR>",      { desc = "Yank full path" })
vim.keymap.set("n", "<leader>ypc", "<cmd>YankPathCwd<CR>",       { desc = "Yank CWD path" })
vim.keymap.set("n", "<leader>yph", "<cmd>YankPathHome<CR>",      { desc = "Yank HOME path" })
vim.keymap.set("n", "<leader>ypu", "<cmd>YankPathUri<CR>",       { desc = "Yank file URI" })
```
</details>

### 🧭 Tip: Works Great with Oil.nvim

If you’re inside an Oil.nvim directory view, the yank commands operate on the **file under cursor**, even if it’s not opened in a buffer.  
This makes it very convenient to copy any file’s path without leaving the explorer.


## 🔧 Configuration

`yank-path.nvim` is configured via the `setup()` function where all fields are optional.

```lua
require("yank-path").setup({
  prompt = "Yank which path?",
  default_mapping = true,
  use_oil = true,   -- enable built-in Oil.nvim integration
})
```

<details>
<summary><strong>Click to expand configuration options</strong></summary>

### `prompt`

Customize the text at the top of the picker window: (for example, `"copy"` or `""`)

```lua
require("yank-path").setup({
  prompt = "copy", -- or "" for a clean look
})
```
<img width="733" height="70" alt="prompt-copy" src="https://github.com/user-attachments/assets/252636fa-ca2d-469f-9813-655c231e6f42" />
<img width="733" height="70" alt="prompt-empty" src="https://github.com/user-attachments/assets/aa384243-0875-4806-8fc6-d711c3d38fe0" />

---

### `default_mapping`

By default, `yank-path.nvim` binds `Y` → `:YankPath` in the Normal mode.
If you prefer a custom keymap (or no keymap at all), you can disable the default mapping:

```lua
require("yank-path").setup({
  default_mapping = false,
})
```

Then you can define your own:

```lua
vim.keymap.set("n", "<leader>yp", "<cmd>YankPath<CR>", { desc = "Yank file path" })
```

---

### `use_oil` — Built-in Oil.nvim support

Oil.nvim works automatically. For some reasons, to disable the integration:

```lua
require("yank-path").setup({
  use_oil = false,
})
```

---

### `register_provider()` — Custom file explorer integrations

`yank-path.nvim` supports integration with any file explorer (Snacks, neo-tree, custom UIs) via small user-provided hooks.

```lua
require("yank-path").register_provider(function()
  local ok, snacks = pcall(require, "snacks")
  if not ok then return nil end

  -- PSEUDOCODE (depends on Snacks API):
  -- local entry = snacks.explorer.get_cursor_entry()
  -- if entry and entry.path then
  --   return entry.path
  -- end

  return nil
end)
```

Provider priority:
1. Built-in Oil provider (if `use_oil = true`)  
2. User-registered providers  
3. Fallback: current buffer path  

</details>

## 🙏 Acknowledgements

This plugin was inspired by great ideas from the following projects:

- **[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)**  
  The `Y` yank-path popup in Neo-tree motivated this plugin's core behavior.

- **[oil.nvim](https://github.com/stevearc/oil.nvim)**  
  A fantastic filesystem UI for Neovim.  
  This plugin includes built-in compatibility to yank paths directly from Oil buffers.

Huge thanks to the authors and contributors of these projects for their amazing work.

## 📝 Note from the Author

This plugin started as a small personal tool to replicate the path-yanking
behavior I liked from Neo-tree, but without requiring a full file explorer.

I'm still relatively new to Neovim plugin development, so while I may not
always be able to expand or maintain the project actively, I'm happy if others
find it useful. Suggestions and contributions are always welcome!

## 🤝 Contributing

Bug reports, improvements, and PRs are welcome!
If you'd like to contribute support for another file explorer, please use
`register_provider()` (see documentation above).

## 📜 License

MIT

---

## ⭐️ Supporting the Project

If this little plugin made your workflow happier, feel free to ⭐️ the repo — it means a lot :)
