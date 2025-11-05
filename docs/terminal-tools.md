# Terminal Tools Guide

Complete documentation for your Nix-managed terminal development environment: Neovim, Tmux, CLI tools, and more.

**Last Updated:** 2025-11-05
**System:** macOS (nix-darwin) + NixOS
**Configuration Type:** Declarative, Nix-managed, Reproducible

---

## Table of Contents

### Neovim
1. [Philosophy & Architecture](#philosophy--architecture)
2. [Configuration Structure](#configuration-structure)
3. [Quick Start](#quick-start)
4. [Leader Key](#leader-key)
5. [Editor Settings](#editor-settings)
6. [Colorschemes & Theming](#colorschemes--theming)
7. [Plugins Overview](#plugins-overview)
8. [Complete Keybindings Reference](#complete-keybindings-reference)
9. [LSP Configuration](#lsp-configuration)
10. [Code Completion](#code-completion)
11. [Formatting & Linting](#formatting--linting)
12. [File Navigation](#file-navigation)
13. [Git Integration](#git-integration)
14. [Customization Guide](#customization-guide)
15. [Tips & Workflows](#tips--workflows)
16. [Troubleshooting](#troubleshooting)

---

## Philosophy & Architecture

This Neovim configuration is **declarative, modular, and fully Nix-managed**:

### Core Principles

- **No plugin manager** - Plugins installed directly via Nix (`pkgs.vimPlugins`)
- **No lazy loading** - Fast startup with all plugins loaded
- **Modular configuration** - Each plugin in its own file
- **Neovim 0.11+ native LSP API** - Modern, built-in LSP configuration
- **Offline-first** - Everything installed via Nix, works without internet
- **Version controlled** - Entire config in Git with Nix flake.lock
- **Reproducible** - Identical setup across all machines

### Benefits

✅ **Clean separation** - Config, keymaps, autocmds all in separate files
✅ **Easy to maintain** - One file per plugin, easy to add/remove
✅ **Reproducible builds** - Nix ensures exact versions
✅ **Works offline** - No runtime downloads
✅ **Fast startup** - Direct loading, no lazy.nvim overhead
✅ **Type-safe** - Nix catches configuration errors at build time

---

## Configuration Structure

```
home/
├── core/
│   └── neovim.nix           # Nix config: plugin list + xdg.configFile setup
├── nvim/
│   ├── init.lua             # Entry point: loads config + plugins
│   └── lua/
│       ├── config/
│       │   ├── options.lua        # Editor settings (line numbers, tabs, etc.)
│       │   ├── keymaps.lua        # General keymaps (window nav, text movement)
│       │   └── autocmds.lua       # Autocommands (transparency, LSP attach, etc.)
│       └── plugins/
│           ├── colorscheme.lua         # Dracula theme configuration
│           ├── lualine.lua             # Status line
│           ├── telescope.lua           # Fuzzy finder + keymaps
│           ├── treesitter.lua          # Syntax highlighting
│           ├── lsp.lua                 # LSP server configuration (Neovim 0.11+ API)
│           ├── none-ls.lua             # External formatters/linters
│           ├── completion.lua          # nvim-cmp setup
│           ├── oil.lua                 # File manager (edit-as-buffer style)
│           ├── neotree.lua             # Traditional file tree explorer
│           ├── git.lua                 # Gitsigns + LazyGit integration
│           ├── which-key.lua           # Keybinding hints
│           ├── undotree.lua            # Undo history visualizer
│           ├── vim-tmux-navigator.lua  # Seamless vim/tmux navigation
│           ├── vim-visual-multi.lua    # Multiple cursors support
│           ├── vimux.lua               # Tmux integration for running commands
│           ├── vim-test.lua            # Test runner (pytest, jest)
│           └── markdown-preview.lua    # Live markdown preview in browser
```

### How It Works

1. **Nix installs plugins** via `programs.neovim.plugins` in `home/core/neovim.nix`
2. **Nix copies config** to `~/.config/nvim/` via `xdg.configFile`
3. **init.lua loads** config files (`options`, `keymaps`, `autocmds`)
4. **init.lua loads** plugin configs (each calls `require('plugin').setup()`)
5. **Plugins are ready** - All configured and working on first launch

---

## Quick Start

### Opening Neovim

```bash
nvim              # Standard
nv                # Shell alias (configured via Nix)
vi                # Alias (viAlias = true)
vim               # Alias (vimAlias = true)
```

### First Steps

1. **Open Neovim**: `nv`
2. **Check health**: `:checkhealth` (verify LSP servers, plugins)
3. **Open file tree**: Press `<leader>e` (Space + e)
4. **Find files**: Press `<leader>ff` (Space + f + f)
5. **See all keybindings**: Press `<leader>` and wait (which-key appears)

### Essential Commands

```vim
:LspInfo          " Check LSP server status
:Telescope        " Browse all telescope commands
:Neotree          " Open file tree
:Oil              " Open directory as buffer
:LazyGit          " Open LazyGit TUI
:checkhealth      " System health check
```

---

## Leader Key

**Leader key is set to `<Space>`**

All custom keybindings that reference `<leader>` mean pressing the spacebar first.

**Example:** `<leader>ff` = Press `Space`, then `f`, then `f`

---

## Editor Settings

Configured in `lua/config/options.lua`:

| Setting | Value | Description |
|---------|-------|-------------|
| `number` | `true` | Show absolute line numbers |
| `relativenumber` | `true` | Show relative line numbers for navigation |
| `expandtab` | `true` | Use spaces instead of tabs |
| `shiftwidth` | `2` | Indent size (2 spaces) |
| `tabstop` | `2` | Tab width (2 spaces) |
| `smartindent` | `true` | Auto-indent new lines intelligently |
| `wrap` | `false` | Don't wrap long lines |
| `termguicolors` | `true` | Enable 24-bit RGB colors |
| `ignorecase` | `true` | Case-insensitive search |
| `smartcase` | `true` | Case-sensitive if uppercase used |
| `signcolumn` | `yes` | Always show sign column (git, diagnostics) |
| `cursorline` | `true` | Highlight current line |
| `scrolloff` | `8` | Keep 8 lines above/below cursor |
| `sidescrolloff` | `8` | Keep 8 columns left/right of cursor |
| `splitright` | `true` | New vertical splits go right |
| `splitbelow` | `true` | New horizontal splits go below |
| `mouse` | `a` | Enable mouse support |
| `clipboard` | `unnamedplus` | Use system clipboard |
| `undofile` | `true` | Persistent undo history |
| `updatetime` | `250ms` | Faster completion |
| `timeoutlen` | `300ms` | Faster key sequence timeout |

---

## Colorschemes & Theming

### Active Theme

**Dracula** - Classic purple/pink dark theme with excellent contrast

### Transparency

Neovim is configured to **respect terminal transparency** (50% opacity from Ghostty config).

All backgrounds are set to `none` via autocmd in `lua/config/autocmds.lua`:
- Normal windows
- Floating windows
- Sign column
- Line numbers
- Status areas

### Available Themes

Installed via Nix in `home/core/neovim.nix`:

- **dracula-nvim** - Purple/pink classic (active)
- **tokyonight-nvim** - Tokyo Night Moon variant (purple accents)
- **catppuccin-nvim** - Catppuccin Mocha variant (purple tones)
- **nightfox-nvim** - Nightfox Carbonfox variant (purple highlights)
- **kanagawa-nvim** - Japanese-inspired dark with subtle purple

### Switching Themes

Edit `home/nvim/lua/plugins/colorscheme.lua`:

```lua
-- Comment out current theme:
-- require('dracula').setup({ ... })
-- vim.cmd('colorscheme dracula')

-- Uncomment desired theme:
require('tokyonight').setup({ style = 'moon', transparent = true })
vim.cmd('colorscheme tokyonight-moon')
```

Then restart Neovim (no rebuild needed - Lua config is live).

---

## Plugins Overview

### Core Infrastructure

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **plenary.nvim** | Lua utility library (required by many plugins) | N/A (dependency) |
| **nvim-web-devicons** | File icons | N/A (dependency) |
| **nui.nvim** | UI components (required by neo-tree) | N/A (dependency) |

### UI & Navigation

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **lualine.nvim** | Status line at bottom | `plugins/lualine.lua` |
| **telescope.nvim** | Fuzzy finder for files, grep, buffers | `plugins/telescope.lua` |
| **telescope-ui-select.nvim** | Better UI for selections (LSP, etc.) | `plugins/telescope.lua` |
| **neo-tree.nvim** | File explorer with tree view | `plugins/neotree.lua` |
| **oil.nvim** | Edit filesystem like a buffer | `plugins/oil.lua` |
| **which-key.nvim** | Keybinding hints popup | `plugins/which-key.lua` |

### Language Support

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **nvim-treesitter** | Syntax highlighting & code understanding | `plugins/treesitter.lua` |
| **none-ls.nvim** | External formatters & linters | `plugins/none-ls.lua` |
| **nvim-cmp** | Autocompletion engine | `plugins/completion.lua` |
| **cmp-nvim-lsp** | LSP completion source | `plugins/completion.lua` |
| **cmp-buffer** | Buffer text completion | `plugins/completion.lua` |
| **cmp-path** | File path completion | `plugins/completion.lua` |
| **luasnip** | Snippet engine | `plugins/completion.lua` |
| **cmp_luasnip** | Snippet completion source | `plugins/completion.lua` |
| **friendly-snippets** | Pre-made snippets | `plugins/completion.lua` |

### Git Integration

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **gitsigns.nvim** | Git diff markers in gutter | `plugins/git.lua` |
| **lazygit.nvim** | LazyGit TUI integration | `plugins/git.lua` |

### Editing Enhancements

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **vim-commentary** | Comment toggling with `gc` motion | N/A (works out of box) |
| **undotree** | Undo history visualizer | `plugins/undotree.lua` |
| **vim-surround** | Surround operations (`ys`, `cs`, `ds`) | N/A (works out of box) |
| **vim-tmux-navigator** | Seamless vim/tmux navigation | `plugins/vim-tmux-navigator.lua` |
| **vim-visual-multi** | Multiple cursors support | `plugins/vim-visual-multi.lua` |

### Testing & Tmux Integration

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **vimux** | Run commands in tmux panes from vim | `plugins/vimux.lua` |
| **vim-test** | Test runner (pytest, jest) with tmux integration | `plugins/vim-test.lua` |

### Markdown

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **markdown-preview.nvim** | Live markdown preview in browser | `plugins/markdown-preview.lua` |

### Colorschemes

| Plugin | Description |
|--------|-------------|
| **dracula-nvim** | Active - Purple/pink theme |
| **tokyonight-nvim** | Alternative - Moon variant |
| **catppuccin-nvim** | Alternative - Mocha variant |
| **nightfox-nvim** | Alternative - Carbonfox |
| **kanagawa-nvim** | Alternative - Subtle purple |

---

## Complete Keybindings Reference

### Leader Key

`<leader>` = `Space`

### General Keymaps

Configured in `lua/config/keymaps.lua`:

#### Window Navigation

**Seamless vim/tmux navigation via vim-tmux-navigator:**

| Key | Action |
|-----|--------|
| `<C-h>` | Go to left window/pane (vim or tmux) |
| `<C-j>` | Go to lower window/pane (vim or tmux) |
| `<C-k>` | Go to upper window/pane (vim or tmux) |
| `<C-l>` | Go to right window/pane (vim or tmux) |
| `<C-\>` | Go to previous window/pane |

These keybindings work seamlessly across vim splits and tmux panes!

#### Window Resizing

| Key | Action |
|-----|--------|
| `<C-Up>` | Increase window height |
| `<C-Down>` | Decrease window height |
| `<C-Left>` | Decrease window width |
| `<C-Right>` | Increase window width |

#### Text Manipulation (Visual Mode)

| Key | Action |
|-----|--------|
| `J` | Move selected text down |
| `K` | Move selected text up |
| `<` | Indent left (stays in visual mode) |
| `>` | Indent right (stays in visual mode) |
| `p` | Paste without replacing clipboard |

#### Utility

| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlight |
| `<leader>w` | Save file |
| `<leader>q` | Quit |

#### Buffer Management

| Key | Action |
|-----|--------|
| `<leader>bd` | Delete buffer |
| `[b` | Previous buffer |
| `]b` | Next buffer |

### Telescope (Fuzzy Finder)

Configured in `lua/plugins/telescope.lua`:

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search text) |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |

**Inside Telescope:**
- `<C-n>` / `<C-j>` / `<Down>` - Next item
- `<C-p>` / `<C-k>` / `<Up>` - Previous item
- `<CR>` - Select item
- `<C-c>` / `<Esc>` - Close

### LSP Keybindings

Configured in `lua/config/autocmds.lua` (LspAttach event):

**Only active in buffers with LSP attached**

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>f` | Format buffer |

### Completion

Configured in `lua/plugins/completion.lua`:

**Active in Insert mode:**

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<C-n>` / `<Tab>` | Next item / Jump to next snippet field |
| `<C-p>` / `<S-Tab>` | Previous item / Jump to previous snippet field |
| `<C-e>` | Abort completion |
| `<C-b>` | Scroll docs up |
| `<C-f>` | Scroll docs down |

### File Navigation

#### Neo-tree (File Explorer)

Configured in `lua/plugins/neotree.lua`:

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree |
| `<leader>fe` | Reveal current file in Neo-tree |

**Inside Neo-tree:**
- `<CR>` - Open file/folder
- `a` - Add file
- `A` - Add directory
- `d` - Delete
- `r` - Rename
- `y` - Copy to clipboard
- `x` - Cut to clipboard
- `p` - Paste from clipboard
- `c` - Copy
- `m` - Move
- `s` - Open in vertical split
- `S` - Open in horizontal split
- `t` - Open in new tab
- `P` - Toggle preview
- `R` - Refresh
- `q` - Close
- `?` - Show help

#### Oil (Edit Filesystem as Buffer)

Configured in `lua/plugins/oil.lua`:

| Key | Action |
|-----|--------|
| `-` | Open parent directory in Oil |

**Inside Oil:**
- Edit like normal buffer (use `dd`, `yy`, `p`, etc.)
- `:w` - Save changes (performs actual file operations)
- `:q` - Quit without saving
- `<CR>` - Open file or enter directory
- `<C-v>` - Open in vertical split
- `<C-s>` - Open in horizontal split
- `g?` - Show help

### Git Integration

Configured in `lua/plugins/git.lua`:

#### LazyGit

| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit |

#### Gitsigns (Git Hunks)

| Key | Action |
|-----|--------|
| `]c` | Next git hunk |
| `[c` | Previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff this ~ |
| `ih` | Select hunk (text object) |

### Editing Enhancements

#### vim-commentary

Comment toggling with motion support:

| Key | Action |
|-----|--------|
| `gc{motion}` | Toggle comments for motion (e.g., `gcap` - comment paragraph) |
| `gcc` | Toggle comment on current line |
| `gc` (Visual) | Toggle comments on selection |

**Examples:**
- `gcc` - Comment current line
- `gcap` - Comment paragraph
- `gc3j` - Comment current line + 3 lines down
- Select lines in visual mode, then `gc` - Comment selection

#### vim-surround

Surround text with quotes, brackets, tags, etc:

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surrounding (e.g., `ysiw"` - surround word with quotes) |
| `cs{old}{new}` | Change surrounding (e.g., `cs"'` - change " to ') |
| `ds{char}` | Delete surrounding (e.g., `ds"` - remove quotes) |
| `yss{char}` | Surround entire line |
| `S{char}` (Visual) | Surround selection |

**Examples:**
- `ysiw"` - Surround current word with double quotes
- `cs"'` - Change surrounding double quotes to single quotes
- `ds{` - Delete surrounding curly braces
- `yss)` - Surround entire line with parentheses
- Select text, then `S<div>` - Surround with `<div></div>`

#### Undotree

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo tree visualizer |

**Inside Undotree:**
- Navigate through undo history with `j/k`
- Press `<Enter>` to restore to selected state
- `q` to close

### Testing & Tmux Integration

#### vim-test

Configured in `lua/plugins/vim-test.lua`:

| Key | Action |
|-----|--------|
| `<leader>tn` | Run test nearest to cursor |
| `<leader>tf` | Run all tests in current file |
| `<leader>ts` | Run entire test suite |
| `<leader>tl` | Run last test |
| `<leader>tv` | Visit test file |

**Supported frameworks:**
- Python: `pytest` (with `-v` flag)
- JavaScript/TypeScript: `jest` (with `--verbose` flag)

Tests run in a tmux pane via vimux integration.

#### Vimux

Run commands in tmux pane from vim:

| Key | Action |
|-----|--------|
| `<leader>vp` | Prompt for command to run |
| `<leader>vl` | Run last command |
| `<leader>vi` | Inspect runner pane |
| `<leader>vz` | Zoom runner pane |
| `<leader>vc` | Interrupt running command |
| `<leader>vq` | Close runner pane |

**Usage example:**
1. Press `<leader>vp` to prompt for command
2. Type command (e.g., `python script.py`)
3. Press `<leader>vl` to re-run the same command
4. Use `<leader>vz` to zoom the tmux pane

### Multiple Cursors (vim-visual-multi)

Edit multiple locations simultaneously:

| Key | Action |
|-----|--------|
| `C-n` | Start multi-cursor on word / Select next occurrence |
| `C-Down` | Create cursor below |
| `C-Up` | Create cursor above |
| `n` | Get next occurrence |
| `N` | Get previous occurrence |
| `q` | Skip current and get next occurrence |
| `Q` | Remove current cursor/selection |
| `[` | Select previous cursor |
| `]` | Select next cursor |
| `Tab` | Switch between cursor and extend mode |
| `Esc` | Exit multi-cursor mode |

**Examples:**
1. **Select all occurrences of a word:**
   - Place cursor on word
   - Press `C-n` multiple times to select each occurrence
   - Edit all at once

2. **Create multiple cursors:**
   - Press `C-n` on a word to start
   - Press `C-n` again to add next occurrence
   - Or use `C-Down/C-Up` to add cursors above/below

3. **Skip an occurrence:**
   - Press `q` to skip current selection and jump to next

### Markdown Preview

Live preview markdown files in browser:

| Key | Action |
|-----|--------|
| `<leader>mp` | Start markdown preview |
| `<leader>ms` | Stop markdown preview |
| `<leader>mt` | Toggle markdown preview |

**Features:**
- Live updates as you type (no need to save)
- Dark theme (matches Dracula aesthetic)
- Automatically opens in your default browser
- Server runs on localhost:8765
- Only works in markdown files (`.md`)

**Usage:**
1. Open a markdown file (`*.md`)
2. Press `<leader>mp` to start preview
3. Edit the file - preview updates live
4. Press `<leader>ms` to stop when done

### Standard Vim Motions

**Navigation:**
- `h/j/k/l` - Left/Down/Up/Right
- `w/b/e` - Word forward/backward/end
- `0/$` - Start/end of line
- `gg/G` - Top/bottom of file
- `{/}` - Previous/next paragraph
- `Ctrl-u/Ctrl-d` - Scroll half page up/down
- `Ctrl-b/Ctrl-f` - Scroll full page up/down

**Editing:**
- `i/a` - Insert before/after cursor
- `I/A` - Insert at start/end of line
- `o/O` - New line below/above
- `dd` - Delete line
- `yy` - Yank (copy) line
- `p/P` - Paste after/before
- `u` - Undo
- `Ctrl-r` - Redo
- `.` - Repeat last command

**Visual mode:**
- `v` - Character-wise visual
- `V` - Line-wise visual
- `Ctrl-v` - Block-wise visual

---

## LSP Configuration

### Architecture

Using **Neovim 0.11+ native LSP API** (`vim.lsp.config`, `vim.lsp.enable`).

**No nvim-lspconfig dependency** - Everything built-in to Neovim 0.11+.

### Configured LSP Servers

Defined in `lua/plugins/lsp.lua`:

| Language | LSP Server | Filetypes | Nix Package | Purpose |
|----------|-----------|-----------|-------------|---------|
| Python | `pyright` | `.py` | `pyright` | Type checking, IntelliSense |
| Python | `ruff` | `.py` | `ruff` | Linting, diagnostics |
| JavaScript/TypeScript | `ts_ls` | `.js`, `.ts`, `.jsx`, `.tsx` | `typescript-language-server` | Type checking, completion |
| Terraform | `terraformls` | `.tf` | `terraform-ls` | HCL support |
| JSON | `jsonls` | `.json` | `vscode-langservers-extracted` | JSON schema validation |
| YAML | `yamlls` | `.yaml`, `.yml` | `yaml-language-server` | YAML validation |
| Bash | `bashls` | `.sh`, `.bash` | `bash-language-server` | Shell script support |
| Docker | `dockerls` | `Dockerfile` | `dockerfile-language-server` | Dockerfile linting |

### Python Setup

**Dual LSP approach:**
- **Pyright** - Type checking, IntelliSense, completions
- **Ruff** - Fast linting and diagnostics

Both run simultaneously, providing comprehensive Python support.

### LSP Features

✅ **Diagnostics** - Real-time error/warning detection
✅ **Code completion** - Context-aware suggestions
✅ **Go to definition** - Jump to symbol definitions
✅ **Find references** - Locate all uses of a symbol
✅ **Hover documentation** - Inline docs on `K`
✅ **Code actions** - Quick fixes and refactorings
✅ **Rename** - Safe project-wide renaming
✅ **Formatting** - Code formatting (via LSP or none-ls)

### Diagnostic Configuration

From `lua/plugins/lsp.lua`:

- Virtual text with `●` prefix
- Severity sorting enabled
- Floating windows with rounded borders
- Hover and signature help use rounded borders

### Adding a New LSP Server

**1. Install via Nix** (`home/core/languages.nix`):
```nix
home.packages = with pkgs; [
  # ... existing
  rust-analyzer  # Example
];
```

**2. Configure in Neovim** (`home/nvim/lua/plugins/lsp.lua`):
```lua
local servers = {
  -- ... existing servers
  rust_analyzer = { filetypes = { 'rust' } },
}
```

**3. Rebuild**:
```bash
darwin-rebuild switch --flake .#m4pro
```

**4. Restart Neovim** - LSP auto-starts on opening Rust files

---

## Code Completion

Powered by **nvim-cmp** with multiple sources.

### Completion Sources

Priority order (configured in `lua/plugins/completion.lua`):

1. **nvim_lsp** - LSP server suggestions (highest priority)
2. **luasnip** - Snippet expansions
3. **path** - File path completions
4. **buffer** - Words from current buffer (lowest priority)

### How It Works

1. Start typing in Insert mode
2. Completion menu appears automatically
3. Navigate with `<Tab>` / `<S-Tab>` or `<C-n>` / `<C-p>`
4. Press `<CR>` to accept
5. Press `<C-Space>` to manually trigger
6. Snippets expand and allow jumping between fields with `<Tab>`

### Snippet Support

**Engine:** LuaSnip
**Collection:** friendly-snippets (VSCode-style snippets)

**Examples:**
- `func` → function template
- `for` → for loop
- `if` → if statement
- `cl` → `console.log` (JavaScript)
- `def` → function definition (Python)

### Visual Indicators

Completion menu shows source:
- `[LSP]` - From LSP server
- `[Snippet]` - From LuaSnip
- `[Path]` - File path
- `[Buffer]` - Buffer text

### Ghost Text

Enabled - Shows inline completion preview in grey text.

---

## Formatting & Linting

Handled by **none-ls.nvim** (modern fork of null-ls).

### Configured Formatters

From `lua/plugins/none-ls.lua`:

| Language | Tool | Nix Package | Purpose |
|----------|------|-------------|---------|
| Python | Black | `black` | Opinionated formatter |
| Python | isort | `isort` | Import sorting |
| JavaScript/TypeScript | Prettier | `prettier` | Code formatting |
| Terraform | terraform_fmt | Built into `terraform` | HCL formatting |
| Shell | shfmt | `shfmt` | Shell script formatting |
| Lua | stylua | `stylua` | Lua formatting |

### Configured Linters

| Language | Tool | Type | Nix Package |
|----------|------|------|-------------|
| Python | Ruff | LSP | `ruff` |

**Note:** Ruff linting is done via LSP server (configured in `lsp.lua`), not via none-ls.

### Manual Formatting

**Format current buffer:** `<leader>f` (Space + f)

Runs asynchronously, won't block editing.

### Format on Save (Optional)

Currently **disabled**. To enable, uncomment in `lua/plugins/none-ls.lua`:

```lua
on_attach = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end,
```

### Adding More Tools

**1. Install via Nix** (`home/core/languages.nix`):
```nix
home.packages = with pkgs; [
  # ... existing
  eslint_d  # Example
];
```

**2. Add to none-ls** (`lua/plugins/none-ls.lua`):
```lua
sources = {
  -- ... existing
  null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.formatting.eslint_d,
}
```

**3. Restart Neovim**

---

## File Navigation

### Two Explorers, Different Use Cases

#### Neo-tree - Visual Tree Explorer

**Best for:**
- Exploring project structure
- Navigating unfamiliar codebases
- Seeing directory hierarchy at a glance
- Visual file management

**Open:** `<leader>e` or `<leader>fe`

**Features:**
- Persistent sidebar
- Tree view with expand/collapse
- Git status integration
- File icons
- Preview mode
- Buffer and symbol views

#### Oil - Edit Filesystem as Buffer

**Best for:**
- Bulk file operations (rename, move, delete)
- Quick edits in current directory
- Vim motion-based file management

**Open:** `-` (dash key)

**Features:**
- Edit filesystem like text
- Use `dd` to delete files
- Use `:s/old/new/` to rename
- Use `yy` and `p` to copy/paste files
- Save with `:w` to apply changes

### Telescope - Fuzzy Finding

**Best for:**
- Finding files by name
- Searching file contents
- Switching buffers
- Browsing help docs

**Key commands:**
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Buffers
- `<leader>fr` - Recent files

### Workflow Recommendations

**Exploring new project:**
1. Open Neo-tree (`<leader>e`)
2. Browse structure
3. Open files from tree

**Quick file operations:**
1. Press `-` to open Oil
2. Edit filenames like text
3. Save with `:w`

**Finding specific file:**
1. Press `<leader>ff`
2. Type part of filename
3. Select with `<CR>`

**Searching for text:**
1. Press `<leader>fg`
2. Type search term
3. Navigate results

---

## Git Integration

### LazyGit (Full Git TUI)

**Open:** `<leader>gg`

LazyGit is a terminal UI for Git with powerful features:

**Inside LazyGit:**
- `1-5` - Switch panels (Status/Files/Branches/Commits/Stash)
- `j/k` - Navigate
- `<Space>` - Stage/unstage files
- `c` - Commit
- `P` - Push
- `p` - Pull
- `x` - Open command menu
- `?` - Help
- `q` - Quit

### Gitsigns (Inline Git Indicators)

**Visual indicators:**
- `│` - Added line (green in gutter)
- `│` - Changed line (blue in gutter)
- `_` - Deleted line (red in gutter)
- `┆` - Untracked file

**Hunk navigation:**
- `]c` - Next hunk
- `[c` - Previous hunk

**Hunk operations:**
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `<leader>hb` - Show blame for line
- `<leader>hd` - Diff current file

**Buffer operations:**
- `<leader>hS` - Stage entire buffer
- `<leader>hR` - Reset entire buffer
- `<leader>hu` - Undo stage hunk

---

## Customization Guide

### Configuration is Split into Modular Files

**Location:** `home/nvim/lua/`

### Adding a New Plugin

**Example: Adding nvim-autopairs**

**1. Install via Nix** (`home/core/neovim.nix`):
```nix
plugins = with pkgs.vimPlugins; [
  # ... existing plugins
  nvim-autopairs
];
```

**2. Create plugin config** (`home/nvim/lua/plugins/autopairs.lua`):
```lua
-- Auto-close brackets, quotes, etc.
require('nvim-autopairs').setup({
  check_ts = true,  -- Use treesitter
  ts_config = {
    lua = { 'string' },
    javascript = { 'template_string' },
  },
})
```

**3. Load in init.lua** (`home/nvim/init.lua`):
```lua
-- Add after existing plugin requires
require('plugins.autopairs')
```

**4. Rebuild**:
```bash
darwin-rebuild switch --flake .#m4pro
```

**5. Restart Neovim**

### Modifying Existing Plugin

**Example: Change telescope layout**

Edit `home/nvim/lua/plugins/telescope.lua`:
```lua
telescope.setup({
  defaults = {
    -- ... existing
    layout_config = {
      width = 0.95,  -- Changed from 0.87
      height = 0.90, -- Changed from 0.80
    },
  },
})
```

**Restart Neovim** (no rebuild needed - Lua is live).

### Adding Keymaps

Edit `home/nvim/lua/config/keymaps.lua`:
```lua
local map = vim.keymap.set

-- Add at end of file
map('n', '<leader>x', '<cmd>MyCommand<CR>', { desc = 'My custom command' })
```

**Restart Neovim**.

### Adding Autocommands

Edit `home/nvim/lua/config/autocmds.lua`:
```lua
-- Add at end of file
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.shiftwidth = 4  -- 4-space indent for Python
    vim.opt_local.tabstop = 4
  end,
})
```

**Restart Neovim**.

### Changing Editor Settings

Edit `home/nvim/lua/config/options.lua`:
```lua
-- Change existing settings
vim.opt.number = false          -- Disable line numbers
vim.opt.wrap = true             -- Enable line wrap
vim.opt.shiftwidth = 4          -- 4-space indent
```

**Restart Neovim**.

### Switching Colorschemes

Edit `home/nvim/lua/plugins/colorscheme.lua`:
```lua
-- Comment out Dracula
-- require('dracula').setup({ ... })
-- vim.cmd('colorscheme dracula')

-- Enable TokyoNight
require('tokyonight').setup({ style = 'moon', transparent = true })
vim.cmd('colorscheme tokyonight-moon')
```

**Restart Neovim**.

---

## Tips & Workflows

### Common Workflows

**Opening a Project:**
```
1. cd /path/to/project
2. nv .
3. <leader>e to browse with Neo-tree
4. <leader>ff to find specific file
```

**Searching Across Project:**
```
1. <leader>fg
2. Type search term
3. <C-n>/<C-p> to navigate
4. <CR> to open file
```

**Refactoring a Variable:**
```
1. Place cursor on variable
2. <leader>rn
3. Type new name
4. <CR> to apply across project
```

**Fixing Errors:**
```
1. ]d to jump to next diagnostic
2. <leader>ca to see code actions
3. Select fix with <CR>
4. <leader>f to format if needed
```

**Bulk File Rename:**
```
1. - to open Oil
2. Use visual mode to select filenames
3. :%s/old/new/g to rename pattern
4. :w to apply changes
```

**Git Commit Flow:**
```
1. Make changes in Neovim
2. <leader>gg to open LazyGit
3. <Space> to stage files
4. c to commit
5. P to push
6. q to return to editing
```

### Performance Tips

- Use `<leader>fb` for open buffers (faster than file search)
- Close unused buffers with `:bd`
- Use relative line numbers (`5j` to jump 5 lines)
- Learn text objects: `ci"` (change in quotes), `da{` (delete around braces)
- Use `.` to repeat last action
- Use `*` to search for word under cursor

### Productivity Boosters

**Multiple cursors alternative:**
```
1. Search with / or *
2. cgn to change next match
3. . to repeat for each occurrence
```

**Quick substitute:**
```
:%s/old/new/g     - Replace in whole file
:s/old/new/g      - Replace in current line
:'<,'>s/old/new/g - Replace in visual selection
```

**Jump list:**
```
<C-o> - Jump to previous location
<C-i> - Jump to next location
```

**Marks:**
```
ma    - Set mark 'a'
'a    - Jump to mark 'a'
```

---

## Troubleshooting

### LSP Not Starting

**Check LSP status:**
```vim
:LspInfo
```

**Verify server installed:**
```bash
which pyright  # Or ts_ls, ruff, etc.
```

**Check filetype detection:**
```vim
:set ft?
```

**Solutions:**
1. Verify LSP package in `home/core/languages.nix`
2. Rebuild Nix config
3. Check server is in PATH: `echo $PATH`
4. Review `:checkhealth` output

### Completion Not Working

**Symptoms:** No completion popup appears

**Checks:**
1. `:LspInfo` - Is LSP attached?
2. Try manual trigger: `<C-Space>`
3. Check `:checkhealth` for cmp errors

**Solutions:**
- Verify `cmp-nvim-lsp` plugin installed
- Restart Neovim
- Check LSP capabilities with `:lua =vim.lsp.get_clients()[1].server_capabilities`

### Transparency Not Working

**Check terminal:**
- Verify Ghostty has `background-opacity = 0.50`
- Other terminals must support transparency

**Check colorscheme:**
```vim
:colorscheme  " Should show 'dracula' or current theme
```

**Verify autocmd:**
- Transparency set in `lua/config/autocmds.lua`
- Autocmd runs on `ColorScheme` and `VimEnter` events

### Colors Look Wrong

**Check true color support:**
```vim
:set termguicolors?  " Should return 'termguicolors'
```

**Verify terminal:**
- Terminal must support 24-bit color
- Set `TERM=xterm-256color` or similar

**Test:**
```bash
curl -s https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash
```

### Neo-tree or Oil Not Opening

**Neo-tree:**
```vim
:Neotree  " Try direct command
:checkhealth neo-tree
```

**Oil:**
```vim
:Oil  " Try direct command
```

**Solutions:**
- Verify plugins installed: `:checkhealth`
- Check for Lua errors: `:messages`
- Verify nui.nvim dependency installed

### None-ls Errors

**Check formatters installed:**
```bash
which black prettier stylua
```

**Verify none-ls:**
```vim
:checkhealth none-ls
```

**Common issues:**
- Formatter not in PATH
- Wrong builtin name
- Tool not installed via Nix

### Performance Issues

**Check startup time:**
```bash
nvim --startuptime startup.log
```

**Profile:**
```vim
:profile start profile.log
:profile func *
:profile file *
" Do some actions
:profile stop
```

**Solutions:**
- All plugins load directly (no lazy loading overhead)
- Check for slow Lua requires
- Verify Nix-installed plugins (faster than runtime downloads)

---

## Quick Reference Card

### Essential Commands

| Task | Keymap |
|------|--------|
| **File Navigation** |
| Find file | `<leader>ff` |
| Search text | `<leader>fg` |
| Recent files | `<leader>fr` |
| File tree | `<leader>e` |
| File manager | `-` |
| **LSP** |
| Go to definition | `gd` |
| Find references | `gr` |
| Hover docs | `K` |
| Rename | `<leader>rn` |
| Code action | `<leader>ca` |
| Format | `<leader>f` |
| **Git** |
| LazyGit | `<leader>gg` |
| Stage hunk | `<leader>hs` |
| Next hunk | `]c` |
| **Testing** |
| Run test nearest | `<leader>tn` |
| Run test file | `<leader>tf` |
| Run last test | `<leader>tl` |
| **Editing** |
| Comment line | `gcc` |
| Surround word | `ysiw"` |
| Undo tree | `<leader>u` |
| Multiple cursors | `C-n` |
| **Markdown** |
| Preview markdown | `<leader>mp` |
| Stop preview | `<leader>ms` |
| **Utility** |
| Save | `<leader>w` |
| Quit | `<leader>q` |
| Keybinding hints | `<leader>` (wait) |

---

## Tmux Integration

Your Neovim setup is deeply integrated with tmux for a powerful terminal workflow.

### Tmux Configuration

**Location:** `home/core/tmux.nix` (Nix-managed, no TPM needed)

**Key features:**
- ✅ **Dracula theme** with status bar at top
- ✅ **Vi keybindings** throughout
- ✅ **Seamless vim/tmux navigation** (C-hjkl works across both)
- ✅ **Nix-managed plugins** (sensible, yank, vim-tmux-navigator)
- ✅ **Catppuccin theme** available as backup (commented out)
- ✅ **Zsh shell** with Starship prompt (not default macOS shell)
- ✅ **Full clipboard integration** (copy to system clipboard)

### Status Bar Configuration

The Dracula theme status bar shows (from left to right):
- **Session name** on the left
- **Battery percentage** (if applicable)
- **Weather** in Celsius for Toronto (configurable)
- **Time** in 24-hour format
- **Date** (day/month)

**Customizing location for weather:**

Edit `home/core/tmux.nix` and change:
```nix
set -g @dracula-fixed-location "Toronto"  # Change to your city
```

**Note:** The weather feature requires internet connectivity. The "redacted" text you saw was the location being hidden for privacy (now disabled with `@dracula-show-location false`).

**Disabling modules:**

To hide battery, weather, or other elements, edit `home/core/tmux.nix`:
```nix
set -g @dracula-show-battery false  # Hide battery
set -g @dracula-show-weather false  # Hide weather
```

Then rebuild with `darwin-rebuild switch --flake .#m4pro`.

### Tmux Keybindings

**Prefix:** `C-a` (Ctrl-a)

#### Essential Commands

| Key | Action |
|-----|--------|
| `C-a` | Prefix key |
| `C-a \|` | Split window vertically |
| `C-a -` | Split window horizontally |
| `C-a h/j/k/l` | Navigate panes (with prefix) |
| `C-h/j/k/l` | Navigate panes (seamless vim/tmux) |
| `C-a H/J/K/L` | Resize pane (hold prefix, repeat H/J/K/L) |
| `C-a s` | Session manager |
| `C-a r` | Reload config |
| `C-a [` | Enter copy mode (vi keys) |

#### Copy Mode (Vi Keys) - Copy to System Clipboard

Tmux has full clipboard integration via the tmux-yank plugin.

| Key | Action |
|-----|--------|
| `C-a [` | Enter copy mode |
| `v` | Begin selection (visual mode) |
| `V` | Begin line selection |
| `C-v` | Rectangle selection (block mode) |
| `y` | Copy selection to system clipboard and exit |
| `Enter` | Copy selection to system clipboard and exit |
| `q` / `Esc` | Exit copy mode without copying |

**How to copy text from tmux:**

1. **Using keyboard:**
   - Press `C-a [` to enter copy mode
   - Navigate with `h/j/k/l` or arrow keys
   - Press `v` to start selection
   - Move cursor to select text
   - Press `y` or `Enter` to copy to system clipboard
   - Paste anywhere with `Cmd+V` (macOS) or `Ctrl+V` (Linux)

2. **Using mouse:**
   - Simply select text with your mouse
   - It's automatically copied to system clipboard
   - Paste anywhere with `Cmd+V` (macOS) or `Ctrl+V` (Linux)

3. **Copy entire pane:**
   - Press `C-a C-c` to copy all visible pane content to clipboard

**Note:** All copied text goes to your system clipboard, not just tmux buffer!

#### Window Management

| Key | Action |
|-----|--------|
| `C-a c` | Create new window |
| `C-a n` | Next window |
| `C-a p` | Previous window |
| `C-a 0-9` | Switch to window number |
| `C-a ,` | Rename window |

---

## Tmux Complete Cheat Sheet

### Starting & Stopping Tmux

| Command | Action |
|---------|--------|
| `tmux` | Start new session |
| `tmux new -s <name>` | Start new session with name |
| `tmux ls` | List all sessions |
| `tmux attach` | Attach to last session |
| `tmux attach -t <name>` | Attach to named session |
| `tmux kill-session -t <name>` | Kill named session |
| `tmux kill-server` | Kill all sessions |

### Session Management (Inside Tmux)

| Key | Action |
|-----|--------|
| `C-a d` | Detach from session (session continues running) |
| `C-a s` | Interactive session list/switcher |
| `C-a $` | Rename current session |
| `C-a (` | Switch to previous session |
| `C-a )` | Switch to next session |

### Window Management

| Key | Action |
|-----|--------|
| `C-a c` | Create new window |
| `C-a ,` | Rename current window |
| `C-a w` | List all windows (interactive) |
| `C-a n` | Next window |
| `C-a p` | Previous window |
| `C-a 0-9` | Switch to window by number |
| `C-a l` | Switch to last used window |
| `C-a &` | Kill current window (with confirmation) |
| `C-a f` | Find window by name |

### Pane Management

| Key | Action |
|-----|--------|
| `C-a \|` | Split pane vertically (left/right) |
| `C-a -` | Split pane horizontally (top/bottom) |
| `C-a h/j/k/l` | Navigate to pane (with prefix) |
| `C-h/j/k/l` | Navigate panes (seamless with vim) |
| `C-a o` | Cycle through panes |
| `C-a ;` | Jump to last active pane |
| `C-a q` | Show pane numbers (type number to switch) |
| `C-a x` | Kill current pane (with confirmation) |
| `C-a !` | Convert pane to window |
| `C-a z` | Toggle pane zoom (full screen) |
| `C-a {` | Move pane left |
| `C-a }` | Move pane right |
| `C-a Space` | Cycle through pane layouts |

### Pane Resizing

| Key | Action |
|-----|--------|
| `C-a H` | Resize left (repeat H while holding prefix) |
| `C-a J` | Resize down |
| `C-a K` | Resize up |
| `C-a L` | Resize right |
| `C-a C-Up/Down/Left/Right` | Resize with arrow keys |

### Copy Mode & Scrolling

| Key | Action |
|-----|--------|
| `C-a [` | Enter copy mode (scroll mode) |
| `h/j/k/l` | Navigate in copy mode (vi keys) |
| `C-u / C-d` | Scroll half page up/down |
| `g / G` | Go to top/bottom |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |
| `v` | Start selection (visual mode) |
| `V` | Start line selection |
| `C-v` | Start rectangle selection |
| `y` | Copy selection to clipboard and exit |
| `Enter` | Copy selection to clipboard and exit |
| `q / Esc` | Exit copy mode |

### Common Workflows

**Creating a Development Layout:**
```bash
# Start tmux
tmux new -s dev

# Split into 3 panes
C-a |          # Split vertically
C-a -          # Split right pane horizontally

# Result:
# ┌─────────┬─────────┐
# │         │         │
# │  Editor │  Shell  │
# │         ├─────────┤
# │         │  Logs   │
# └─────────┴─────────┘
```

**Working Across Multiple Projects:**
```bash
# Create sessions for each project
tmux new -s project1
C-a d                    # Detach

tmux new -s project2
C-a d                    # Detach

# Switch between them
tmux attach -t project1
tmux attach -t project2

# Or use C-a s to see interactive list
```

**Copying Text:**
```bash
# Method 1: Vi-style
C-a [           # Enter copy mode
/pattern        # Search for text
n               # Jump to next match
v               # Start selection
jjj             # Extend selection
y               # Copy and exit

# Method 2: Mouse
Just select with mouse - automatically copies!

# Paste
Cmd+V (macOS) or Ctrl+V (Linux)
```

**Detach & Reattach:**
```bash
# Inside tmux
C-a d           # Detach (session keeps running)

# Later, from terminal
tmux attach     # Reattach to session

# Everything is still there - windows, panes, processes!
```

**Kill Stuck Pane:**
```bash
C-a x           # Kill current pane (asks confirmation)
# or
C-a q           # Show pane numbers
C-a : kill-pane -t 2    # Kill pane 2
```

### Tips & Tricks

**1. Tmux Persists Across Terminal Restarts**
- Close your terminal app - tmux sessions keep running!
- Reopen terminal, run `tmux attach` - everything's still there

**2. Mouse Support**
- Enabled by default in this config
- Click to switch panes
- Click and drag to resize panes
- Select text with mouse to copy

**3. Zoom a Pane**
- `C-a z` - Make current pane full screen
- Work in it
- `C-a z` again - Restore layout

**4. Renaming is Your Friend**
```bash
C-a ,           # Rename window to something meaningful
C-a $           # Rename session to project name
```

**5. Quick Pane Creation**
```bash
# Create 4-pane layout quickly
C-a |  C-a -  C-a h  C-a -
```

**6. Scrollback Search**
```bash
C-a [           # Enter copy mode
/error          # Search for "error"
n n n           # Jump through matches
q               # Exit when done
```

---

### Seamless Vim/Tmux Navigation

With vim-tmux-navigator, these keys work identically whether you're in a vim split or tmux pane:

- `C-h` - Move left
- `C-j` - Move down
- `C-k` - Move up
- `C-l` - Move right
- `C-\` - Move to previous

**No need to think about whether you're in vim or tmux!**

### Vimux Integration

Run commands in a tmux pane from within Neovim:

1. Open Neovim in tmux
2. Press `<leader>vp` to prompt for a command
3. Type your command (e.g., `pytest tests/`)
4. The command runs in a tmux pane
5. Press `<leader>vl` to re-run the last command

**Use case:** Run tests, build scripts, or any CLI command without leaving Neovim.

### vim-test Integration

Tests automatically run in tmux panes via vimux:

1. Open a test file in Neovim (in tmux)
2. Press `<leader>tn` to run the test nearest to cursor
3. Tests run in a tmux pane below
4. See results without leaving Neovim
5. Press `<leader>tl` to re-run the last test

**Supported:**
- Python: `pytest -v`
- JavaScript/TypeScript: `jest --verbose`

### Tmux + Neovim Workflow

**Typical session layout:**

```
┌─────────────────────────────────────┐
│ tmux status bar (top, Dracula)     │
├─────────────────────────────────────┤
│                                     │
│   Neovim (main editor)             │
│                                     │
├─────────────────────────────────────┤
│   Test output / Command runner     │
│   (vimux pane)                      │
└─────────────────────────────────────┘
```

**Workflow:**
1. Edit code in Neovim (top pane)
2. Run tests with `<leader>tn`
3. See results in bottom pane (vimux)
4. Navigate between panes with `C-j/k`
5. Fix issues, re-run with `<leader>tl`

### Switching Tmux Theme

To use Catppuccin instead of Dracula:

1. Edit `home/core/tmux.nix`
2. Comment out the Dracula plugin block
3. Uncomment the Catppuccin plugin block
4. Rebuild: `darwin-rebuild switch --flake .#m4pro`

---

## Spotify TUI (spotify-player)

Control Spotify from your terminal with a beautiful TUI.

### First Time Setup

**Prerequisites:**
- Spotify Premium account (required for playback control)
- Spotify app installed and logged in on your machine

**Initial Authentication:**

1. Start spotify-player:
```bash
spotify-player
```

2. On first run, you'll see authentication instructions
3. Follow the prompts to authenticate with Spotify
4. Credentials are saved to `~/.config/spotify-player/`

### Features

- ✅ **Full playback control** - Play, pause, skip, seek
- ✅ **Browse library** - Playlists, albums, artists, podcasts
- ✅ **Search** - Find any track, album, or artist
- ✅ **Queue management** - Add tracks, reorder, clear
- ✅ **Vi keybindings** - Navigate like vim
- ✅ **Dracula theme** - Matches your terminal aesthetic
- ✅ **Album art** - Shows cover art in terminal
- ✅ **Device selection** - Control playback on any device

### Keybindings

#### Navigation

| Key | Action |
|-----|--------|
| `j` / `Down` | Next item |
| `k` / `Up` | Previous item |
| `h` / `Left` | Go back / Collapse |
| `l` / `Right` / `Enter` | Select / Expand |
| `g` | Go to top |
| `G` | Go to bottom |
| `Tab` | Switch focus between panels |

#### Playback Control

| Key | Action |
|-----|--------|
| `Space` | Play / Pause |
| `n` | Next track |
| `p` | Previous track |
| `+` / `=` | Volume up |
| `-` / `_` | Volume down |
| `m` | Mute / Unmute |
| `s` | Toggle shuffle |
| `r` | Cycle repeat mode (off → track → context) |
| `.` | Seek forward 5 seconds |
| `,` | Seek backward 5 seconds |

#### Library & Search

| Key | Action |
|-----|--------|
| `/` | Search |
| `1` | Browse playlists |
| `2` | Browse saved albums |
| `3` | Browse saved tracks (liked songs) |
| `4` | Browse artists |
| `5` | Browse podcasts |

#### Queue Management

| Key | Action |
|-----|--------|
| `a` | Add track to queue |
| `A` | Add album/playlist to queue |
| `d` | Delete track from queue |
| `D` | Clear queue |

#### Other

| Key | Action |
|-----|--------|
| `?` | Show help (all keybindings) |
| `q` | Quit |
| `R` | Refresh / Reload |
| `i` | Show track/album info |
| `o` | Show queue |
| `O` | Show playback devices |
| `x` | Like/unlike current track |

### Common Workflows

**Playing Music:**
```bash
# Start spotify-player
spotify-player

# Navigate to playlists
Press 1

# Use j/k to navigate, Enter to select
# Press Space to play/pause
# Press n for next track
```

**Searching for Music:**
```bash
# Inside spotify-player
Press /
Type: artist name or song
Press Enter

# Navigate results with j/k
# Press Enter to play
# Press a to add to queue
```

**Managing Queue:**
```bash
# Show current queue
Press o

# Add track to queue
Navigate to track, press a

# Clear queue
Press D
```

**Controlling Other Devices:**
```bash
# Show available devices
Press O

# Select device to control
Use j/k to navigate, Enter to select

# Control playback on that device
# Works with phones, speakers, etc!
```

### Tips & Tricks

**1. Use as Background Player**
- spotify-player connects to Spotify web API
- You can control the official Spotify app
- Or let it play independently

**2. Terminal-Only Mode**
- Close Spotify app completely
- spotify-player will handle playback
- Perfect for terminal-only workflows!

**3. Quick Track Info**
```bash
Press i        # Show detailed track info
Press x        # Like/unlike track
Press a        # Add to queue
```

**4. Device Switching**
- Press `O` to see all devices
- Switch playback between:
  - Your Mac
  - Phone
  - Speakers
  - Other computers

**5. Search Shortcuts**
```bash
/spotify:playlist:<id>    # Search for specific playlist
/album:<name>             # Search albums only
/artist:<name>            # Search artists only
```

### Configuration

**Location:** `~/.config/spotify-player/app.toml`

**Key settings:**
- Theme: Dracula (matches your terminal)
- Keybindings: Vi-style by default
- Backend: `spotify_connect` (requires Premium)

**To customize:**
1. Edit `home/spotify-player/app.toml` in your nix-config
2. Rebuild: `darwin-rebuild switch --flake .#m4pro`
3. Restart spotify-player

### Troubleshooting

**Authentication Issues:**
```bash
# Clear saved credentials
rm -rf ~/.config/spotify-player/credentials.json

# Re-authenticate
spotify-player
```

**No Audio / Can't Control:**
- Verify Spotify Premium is active
- Check that Spotify app is logged in
- Try restarting spotify-player

**Can't See Devices:**
```bash
# Make sure Spotify app is running
# Or use other Spotify-enabled devices

# Refresh device list
Press R
```

---

**Configuration maintained with ❤️ via Nix**
**Last updated:** 2025-11-05
