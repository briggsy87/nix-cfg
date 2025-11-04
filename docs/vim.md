# Neovim Configuration Guide

Complete documentation for the Nix-managed Neovim setup with LSP, Treesitter, and modern plugins.

---

## Table of Contents

1. [Philosophy & Architecture](#philosophy--architecture)
2. [Leader Key](#leader-key)
3. [Editor Settings](#editor-settings)
4. [Colorschemes & Theming](#colorschemes--theming)
5. [Plugins Overview](#plugins-overview)
6. [Keybindings Reference](#keybindings-reference)
7. [LSP (Language Server Protocol)](#lsp-language-server-protocol)
8. [Code Completion](#code-completion)
9. [Formatting & Linting](#formatting--linting)
10. [File Navigation](#file-navigation)
11. [Git Integration](#git-integration)
12. [Tips & Workflows](#tips--workflows)

---

## Philosophy & Architecture

This Neovim configuration is **fully declarative** and managed through Nix:

- **No package managers inside Neovim** (no Mason, no Packer, no lazy.nvim)
- **All plugins** installed via `pkgs.vimPlugins` in `home/shared.nix`
- **All LSP servers, formatters, and linters** installed as Nix packages
- **Configuration** in `home/nvim/init.lua` loaded via `extraLuaConfig`
- **Uses Neovim 0.11+ native LSP API** (no nvim-lspconfig dependency)

**Benefits:**
- Reproducible across all machines
- Version controlled and portable
- No plugin conflicts or version mismatches
- Works offline (no runtime downloads)

---

## Leader Key

**Leader key is set to `<Space>`**

All custom keybindings in this guide that reference `<leader>` mean pressing the spacebar first.

Example: `<leader>ff` = Press `Space`, then `f`, then `f`

---

## Editor Settings

Configured in `home/nvim/init.lua:4-12`:

| Setting | Value | Description |
|---------|-------|-------------|
| `number` | `true` | Show absolute line numbers |
| `relativenumber` | `true` | Show relative line numbers for easy navigation |
| `expandtab` | `true` | Use spaces instead of tabs |
| `shiftwidth` | `2` | Indent size (2 spaces) |
| `tabstop` | `2` | Tab width (2 spaces) |
| `smartindent` | `true` | Auto-indent new lines intelligently |
| `wrap` | `false` | Don't wrap long lines |
| `termguicolors` | `true` | Enable 24-bit RGB colors |

---

## Colorschemes & Theming

### Active Theme
**TokyoNight Moon** - Dark theme with purple accents and transparency support

### Transparency
Neovim is configured to respect terminal transparency (50% opacity from Ghostty config).
All backgrounds are set to `none` so the terminal background shows through.

The colorscheme loader automatically tries themes in this order:
1. TokyoNight Moon (purple accents)
2. Catppuccin Mocha (purple tones)
3. Kanagawa (subtle purple)
4. Carbonfox (purple highlights)
5. Habamax (built-in fallback)

### Switching Themes

Uncomment one of these lines in `home/nvim/init.lua:66-70` to override the default:

```lua
-- Purple/Dark theme options:
-- vim.cmd('colorscheme tokyonight-moon')   -- Active default (purple accents)
-- vim.cmd('colorscheme catppuccin-mocha')  -- Purple-toned variant
-- vim.cmd('colorscheme carbonfox')         -- Dark with purple highlights
-- vim.cmd('colorscheme kanagawa')          -- Subtle purple/dark theme
```

**After changing, rebuild your Nix config:**
```bash
darwin-rebuild switch --flake .#m4pro
```

### Available Colorscheme Plugins

Installed in `home/shared.nix:116-119`:

- **tokyonight-nvim** - Tokyo Night Moon variant (purple accents) - **Active**
- **catppuccin-nvim** - Catppuccin Mocha variant (purple tones)
- **nightfox-nvim** - Nightfox family (Carbonfox has purple highlights)
- **kanagawa-nvim** - Japanese-inspired dark theme with subtle purple

---

## Plugins Overview

### Essential Plugins

| Plugin | Purpose | Config Location |
|--------|---------|----------------|
| **plenary.nvim** | Lua utility library (required by many plugins) | Dependency only |
| **telescope.nvim** | Fuzzy finder for files, grep, buffers, etc. | `init.lua:51-55` |
| **nvim-treesitter** | Syntax highlighting and code understanding | `init.lua:58-69` |
| **none-ls.nvim** | Formatting and linting integration | `init.lua:117-130` |
| **nvim-cmp** | Autocompletion engine | `init.lua:133-149` |
| **cmp-nvim-lsp** | LSP completion source for nvim-cmp | Auto-configured |
| **cmp-buffer** | Buffer completion source | Auto-configured |
| **cmp-path** | File path completion source | Auto-configured |
| **luasnip** | Snippet engine | `init.lua:135-136` |
| **friendly-snippets** | Pre-made snippet collection | Auto-loaded |
| **gitsigns.nvim** | Git integration (diff markers, hunks) | `init.lua:158` |
| **lazygit.nvim** | LazyGit terminal UI integration | `init.lua:157` |
| **oil.nvim** | File manager (edit filesystem like a buffer) | `init.lua:152-153` |
| **which-key.nvim** | Keybinding hints/documentation | Auto-configured |

---

## Keybindings Reference

### Telescope (Fuzzy Finding)

Located in `init.lua:51-55`

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>ff` | Find files | Search files in current directory |
| `<leader>fg` | Live grep | Search text across all files |
| `<leader>fb` | Buffers | List and switch between open buffers |
| `<leader>fh` | Help tags | Search Neovim help documentation |

**Telescope Controls (once open):**
- `<C-n>` / `<Down>` - Next item
- `<C-p>` / `<Up>` - Previous item
- `<CR>` - Select item
- `<C-c>` / `<Esc>` - Close
- `<C-u>` / `<C-d>` - Scroll preview up/down

### LSP (Language Server Protocol)

Configured via `LspAttach` autocmd in `init.lua:75-91`

These keybindings are **only active in buffers with an LSP attached**:

| Keybinding | Action | Description |
|------------|--------|-------------|
| `gd` | Go to definition | Jump to where symbol is defined |
| `gr` | Go to references | Find all references to symbol |
| `K` | Hover documentation | Show docs for symbol under cursor |
| `<leader>rn` | Rename | Rename symbol across project |
| `<leader>ca` | Code action | Show available code actions |
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |
| `<leader>f` | Format buffer | Format code (async) |

### Code Completion

Configured in `init.lua:133-149`

Active in **Insert mode**:

| Keybinding | Action |
|------------|--------|
| `<C-Space>` | Trigger completion manually |
| `<CR>` | Confirm selected completion |
| `<Tab>` | Select next completion item |
| `<S-Tab>` | Select previous completion item |

Completion sources (in order):
1. LSP suggestions
2. File paths
3. Buffer words
4. Snippets

### File Navigation (Oil.nvim)

Configured in `init.lua:152-153`

| Keybinding | Action | Description |
|------------|--------|-------------|
| `-` | Open Oil | Edit parent directory as a buffer |

**Inside Oil buffer:**
- Edit the buffer like normal text (add/delete/rename files)
- `<CR>` - Open file or directory
- `:w` - Save changes (actually performs file operations)
- `:q` - Quit without saving changes
- `g?` - Show help

**Example workflow:**
1. Press `-` to open current directory
2. Use `dd` to delete a file line
3. Use `o` to create a new line and type filename
4. Press `:w` to apply changes to filesystem

### Git Integration

Configured in `init.lua:157-158`

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>gg` | LazyGit | Open LazyGit terminal UI |

**GitSigns** (gitsigns.nvim) provides:
- Diff indicators in sign column (added/changed/deleted lines)
- Inline git blame (configurable)

### General Vim Motions

Standard Vim keybindings are available:

**Navigation:**
- `h/j/k/l` - Left/Down/Up/Right
- `w/b` - Forward/backward word
- `0/$` - Start/end of line
- `gg/G` - Top/bottom of file
- `{/}` - Previous/next paragraph
- `Ctrl-u/Ctrl-d` - Scroll up/down half page

**Editing:**
- `i/a` - Insert before/after cursor
- `I/A` - Insert at start/end of line
- `o/O` - New line below/above
- `dd` - Delete line
- `yy` - Yank (copy) line
- `p/P` - Paste after/before cursor
- `u` - Undo
- `Ctrl-r` - Redo
- `.` - Repeat last command

**Visual mode:**
- `v` - Character-wise visual
- `V` - Line-wise visual
- `Ctrl-v` - Block-wise visual

---

## LSP (Language Server Protocol)

### Supported Languages

Configured in `init.lua:93-101`:

| Language | LSP Server | Filetypes | Nix Package |
|----------|-----------|-----------|-------------|
| Python | Pyright | `.py` | `pyright` |
| JavaScript/TypeScript | ts_ls | `.js`, `.ts`, `.jsx`, `.tsx` | `typescript-language-server` |
| Terraform | terraformls | `.tf` | `terraform-ls` |
| JSON | jsonls | `.json` | `vscode-langservers-extracted` |
| YAML | yamlls | `.yaml`, `.yml` | `yaml-language-server` |
| Bash/Shell | bashls | `.sh`, `.bash` | `bash-language-server` |
| Dockerfile | dockerls | `Dockerfile` | `dockerfile-language-server` |

### How LSP Works

1. **Auto-start**: When you open a file, Neovim detects the filetype
2. **Root detection**: Finds project root by looking for `.git` or `.gitignore`
3. **Server launch**: Starts the appropriate LSP server
4. **Capabilities**: Enables completions, diagnostics, formatting, etc.
5. **Keybindings**: LSP-specific keys become available via `LspAttach` event

### LSP Features

- **Diagnostics**: Real-time error/warning detection
- **Code completion**: Context-aware suggestions
- **Go to definition**: Jump to symbol definitions
- **Find references**: Locate all uses of a symbol
- **Hover documentation**: Inline docs
- **Code actions**: Quick fixes and refactorings
- **Rename**: Safe project-wide renaming
- **Formatting**: Code formatting

### Adding a New LSP Server

1. **Install LSP in Nix**:
   ```nix
   # In home/shared.nix, add to home.packages:
   rust-analyzer  # Example
   ```

2. **Configure in init.lua**:
   ```lua
   -- Add to servers table around line 93:
   local servers = {
     -- ... existing servers
     rust_analyzer = { filetypes = { 'rust' } },
   }
   ```

3. **Rebuild**: `darwin-rebuild switch --flake .#m4pro`

---

## Code Completion

Powered by **nvim-cmp** with multiple sources.

### Completion Sources

Configured in `init.lua:146-147`:

1. **nvim_lsp** - LSP server suggestions (highest priority)
2. **path** - File path completions
3. **buffer** - Words from current buffer
4. **luasnip** - Snippet expansions

### How It Works

- Type code normally
- Completion menu appears automatically
- Use `<Tab>` / `<S-Tab>` to navigate
- Press `<CR>` to accept
- Press `<C-Space>` to manually trigger

### Snippets

Powered by **LuaSnip** with **friendly-snippets** collection.

Example snippets:
- `func` → function template
- `for` → for loop
- `if` → if statement
- `cl` → console.log (JavaScript)

---

## Formatting & Linting

Handled by **none-ls.nvim** (formerly null-ls).

### Configured Formatters

From `init.lua:120-126`:

| Language | Tool | Nix Package |
|----------|------|-------------|
| Python | Black + isort | `black`, `isort` |
| JavaScript/TypeScript | Prettier | `prettier` |
| Terraform | terraform_fmt | Built into `terraform` |
| Shell | shfmt | `shfmt` |
| Lua | stylua | `stylua` |

### Configured Linters

| Language | Tool | Nix Package |
|----------|------|-------------|
| Python | Ruff | `ruff` |

### Using Formatters

**Automatic on save**: Not configured by default
**Manual formatting**: Press `<leader>f` in normal mode

### Adding More Tools

1. **Install in Nix**:
   ```nix
   # In home/shared.nix:
   eslint_d  # Example
   ```

2. **Add to none-ls**:
   ```lua
   -- In init.lua, add to sources:
   null_ls.builtins.diagnostics.eslint_d,
   null_ls.builtins.formatting.eslint_d,
   ```

3. **Rebuild**

---

## File Navigation

### Telescope

**Best for**: Finding files by name or content

```
<leader>ff - Find files (fuzzy search filenames)
<leader>fg - Live grep (search file contents)
<leader>fb - Browse open buffers
```

**Pro tips:**
- Start typing immediately to filter
- Use space to separate search terms (AND search)
- `!term` excludes results containing `term`

### Oil.nvim

**Best for**: Bulk file operations (rename, delete, move)

```
- (dash key) - Open parent directory
```

**Workflow:**
1. Press `-` to open directory as buffer
2. Edit like normal text:
   - `dd` to delete file
   - `i` to rename file
   - `o` to create new file
3. Save with `:w` to apply changes

**Example - Renaming multiple files:**
```
1. Press `-`
2. Visual select multiple lines (V)
3. Use `:%s/old/new/g` to rename pattern
4. Press :w to apply
```

### Netrw (Built-in, fallback)

If Oil doesn't work, use `:Ex` to open Netrw file explorer.

---

## Git Integration

### LazyGit

Press `<leader>gg` to open **LazyGit** - a full-featured Git TUI.

**LazyGit controls:**
- `1-5` - Switch panels (Status/Files/Branches/Commits/Stash)
- `j/k` - Navigate
- `<Space>` - Stage/unstage files
- `c` - Commit
- `P` - Push
- `p` - Pull
- `x` - Open menu
- `?` - Help

### GitSigns

**gitsigns.nvim** provides:
- **Sign column indicators**: `+` added, `~` changed, `-` deleted
- **Inline blame**: Shows git blame info (can be toggled)
- **Hunk operations**: Stage/unstage individual hunks

Future keybindings can be added for:
- `]c` / `[c` - Next/previous hunk
- `<leader>hs` - Stage hunk
- `<leader>hu` - Undo hunk
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line

---

## Tips & Workflows

### Common Workflows

**Opening a project:**
```
1. cd /path/to/project
2. nvim .
3. Press <leader>ff to find files
4. Start editing
```

**Searching for text across project:**
```
1. <leader>fg
2. Type search term
3. Navigate results with Ctrl-n/p
4. Press Enter to jump to file
```

**Refactoring a variable:**
```
1. Place cursor on variable
2. Press <leader>rn
3. Type new name
4. Press Enter
```

**Fixing errors:**
```
1. Open file with diagnostics
2. Press ]d to jump to next error
3. Press <leader>ca to see code actions
4. Select fix and press Enter
```

**Quick file operations:**
```
1. Press - to open directory
2. Delete unwanted files with dd
3. Rename with ciw (change inner word)
4. Press :w to apply changes
```

### Combining Tools

**Find and replace across project:**
```
1. <leader>fg to search for term
2. Note the files with matches
3. Open quickfix with :copen
4. Use :cfdo %s/old/new/g | update
```

**Git workflow:**
```
1. Make changes in Neovim
2. <leader>gg to open LazyGit
3. Stage/commit/push
4. Close LazyGit to return to editing
```

### Performance Tips

- Use `<leader>fb` instead of `<leader>ff` when switching between already-open files
- Close unused buffers with `:bd` to reduce memory
- Use relative line numbers (`5j` to jump 5 lines down)
- Learn text objects: `ci"` (change inside quotes), `da{` (delete around braces)

### Debugging

**Check LSP status:**
```
:LspInfo
```

**Check diagnostics:**
```
:lua vim.diagnostic.open_float()
```

**Treesitter info:**
```
:TSInstallInfo
```

**Plugin health:**
```
:checkhealth
```

### Learning Resources

- **Vim tutorial**: Run `vimtutor` in terminal
- **Neovim docs**: Press `<leader>fh` and search
- **Which-key**: Press `<leader>` and wait to see available bindings
- **Command history**: Press `q:` to browse command history

---

## Summary of All Keybindings

| Category | Key | Action |
|----------|-----|--------|
| **Telescope** | `<leader>ff` | Find files |
| | `<leader>fg` | Live grep |
| | `<leader>fb` | Buffers |
| | `<leader>fh` | Help tags |
| **LSP** | `gd` | Go to definition |
| | `gr` | Go to references |
| | `K` | Hover docs |
| | `<leader>rn` | Rename |
| | `<leader>ca` | Code action |
| | `[d` | Previous diagnostic |
| | `]d` | Next diagnostic |
| | `<leader>f` | Format |
| **Completion** | `<C-Space>` | Trigger completion |
| | `<CR>` | Confirm |
| | `<Tab>` | Next item |
| | `<S-Tab>` | Previous item |
| **Files** | `-` | Open Oil |
| **Git** | `<leader>gg` | LazyGit |

---

## Customization

All configuration lives in **two places**:

1. **Plugins** - `home/shared.nix` (lines 98-121)
2. **Config** - `home/nvim/init.lua`

**To customize:**
1. Edit the files
2. Run: `darwin-rebuild switch --flake .#m4pro`
3. Restart Neovim

**Safe to experiment** - Nix makes it easy to roll back if something breaks!

---

## Troubleshooting

### LSP not starting

1. Check `:LspInfo` - is server installed?
2. Verify package in `home/shared.nix`
3. Check filetype: `:set ft?`
4. Rebuild Nix config

### Completion not working

1. Check if LSP is attached: `:LspInfo`
2. Verify `cmp-nvim-lsp` plugin is installed
3. Try manual trigger: `<C-Space>`

### Transparency not working

1. Check terminal supports transparency (Ghostty does)
2. Verify `background-opacity` in `home/ghostty/config`
3. Make sure colorscheme is loaded: `:colorscheme`

### Colors look wrong

1. Ensure `termguicolors` is set: `:set termguicolors?`
2. Try different colorscheme
3. Check terminal supports 24-bit color

---

**Last updated**: 2025-11-04
**Configuration version**: Neovim 0.11+ with native LSP
