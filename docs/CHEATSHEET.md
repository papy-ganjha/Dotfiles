# Neovim & Tmux Configuration Cheatsheet

## Table of Contents
- [Tmux](#tmux)
- [Neovim](#neovim)
  - [General Keymaps](#general-keymaps)
  - [Window Management](#window-management)
  - [Tab Management](#tab-management)
  - [File Navigation (Telescope)](#file-navigation-telescope)
  - [File Explorer (NvimTree)](#file-explorer-nvimtree)
  - [LSP & Code Navigation](#lsp--code-navigation)
  - [Refactoring](#refactoring)
  - [Documentation](#documentation)

---

## Tmux

### Prefix Key
The prefix key has been changed from `Ctrl+b` to **`Ctrl+a`**

### Window Splitting
| Keybinding | Action |
|------------|--------|
| `Ctrl+a` then `\|` | Split window vertically |
| `Ctrl+a` then `-` | Split window horizontally |

### Pane Navigation
| Keybinding | Action |
|------------|--------|
| `Ctrl+h` | Navigate to left pane (vim-tmux-navigator) |
| `Ctrl+j` | Navigate to pane below (vim-tmux-navigator) |
| `Ctrl+k` | Navigate to pane above (vim-tmux-navigator) |
| `Ctrl+l` | Navigate to right pane (vim-tmux-navigator) |

### Pane Resizing
| Keybinding | Action |
|------------|--------|
| `Ctrl+a` then `h` | Resize pane left (5 units) |
| `Ctrl+a` then `j` | Resize pane down (5 units) |
| `Ctrl+a` then `k` | Resize pane up (5 units) |
| `Ctrl+a` then `l` | Resize pane right (5 units) |
| `Ctrl+a` then `m` | Toggle maximize/minimize pane |

### Configuration
| Keybinding | Action |
|------------|--------|
| `Ctrl+a` then `r` | Reload tmux configuration |

### Copy Mode (Vim-style)
| Keybinding | Action |
|------------|--------|
| `Ctrl+a` then `[` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Copy selection (in copy mode) |

### Features
- **Mouse support**: Enabled for easy pane selection and resizing
- **Session persistence**: tmux-resurrect saves sessions (survives restarts)
- **Auto-save**: tmux-continuum saves sessions every 15 minutes
- **Theme**: Powerline cyan theme

### Plugin Management
| Keybinding | Action |
|------------|--------|
| `Ctrl+a` then `Shift+i` | Install tmux plugins (TPM) |
| `Ctrl+a` then `Shift+u` | Update tmux plugins (TPM) |

---

## Neovim

### Leader Key
The leader key is set to **`Space`**

## General Keymaps

### Basic Operations
| Keybinding | Mode | Action |
|------------|------|--------|
| `jk` | Insert | Exit insert mode (alternative to `Esc`) |
| `Space w` | Normal | Save current file |
| `Space nh` | Normal | Clear search highlights |

### Numbers
| Keybinding | Mode | Action |
|------------|------|--------|
| `Space +` | Normal | Increment number under cursor |
| `Space -` | Normal | Decrement number under cursor |

## Window Management

### Split Windows
| Keybinding | Mode | Action |
|------------|------|--------|
| `Space sv` | Normal | Split window vertically |
| `Space sh` | Normal | Split window horizontally |
| `Space se` | Normal | Make split windows equal width |
| `Space sx` | Normal | Close current split window |
| `Space sm` | Normal | Toggle maximize current window |

### Navigation Between Windows
Use `Ctrl+h/j/k/l` to navigate between splits (works seamlessly with Tmux panes via vim-tmux-navigator)

## Tab Management

| Keybinding | Mode | Action |
|------------|------|--------|
| `Space to` | Normal | Open new tab |
| `Space tx` | Normal | Close current tab |
| `Space tn` | Normal | Go to next tab |
| `Space tp` | Normal | Go to previous tab |

## File Navigation (Telescope)

### Fuzzy Finding
| Keybinding | Mode | Action |
|------------|------|--------|
| `Space ff` | Normal | Find files in project |
| `Space fs` | Normal | Live grep (search text in files) |
| `Space fc` | Normal | Search for word under cursor |
| `Space fb` | Normal | Browse open buffers |
| `Space fh` | Normal | Search help tags |

### Telescope Navigation (in Telescope window)
| Keybinding | Mode | Action |
|------------|------|--------|
| `Ctrl+j` | Insert | Move to next result |
| `Ctrl+k` | Insert | Move to previous result |
| `Ctrl+q` | Insert | Send selected to quickfix list |
| `Enter` | Insert | Open selected file |

## File Explorer (NvimTree)

| Keybinding | Mode | Action |
|------------|------|--------|
| `Space e` | Normal | Toggle NvimTree file explorer |

### Inside NvimTree
- `Enter` - Open file/folder
- `a` - Create new file/folder
- `d` - Delete file/folder
- `r` - Rename file/folder
- `x` - Cut file/folder
- `c` - Copy file/folder
- `p` - Paste file/folder
- `R` - Refresh tree
- `?` - Show help

## LSP & Code Navigation

### LSP Saga
LSP features are provided via LSPSaga. Common keybindings:

| Keybinding | Mode | Action |
|------------|------|--------|
| `Ctrl+f` | Normal | Scroll down in LSP preview |
| `Ctrl+b` | Normal | Scroll up in LSP preview |
| `Enter` | Normal | Open file from definition preview |

### Common LSP Commands (check your LSP config)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Show references
- `K` - Show hover documentation

## Refactoring

All refactoring commands start with `Space r`

| Keybinding | Mode | Action |
|------------|------|--------|
| `Space re` | Visual | Extract selection to function |
| `Space rf` | Visual | Extract selection to file |
| `Space rv` | Visual | Extract to variable |
| `Space ri` | Normal/Visual | Inline variable |
| `Space rI` | Normal | Inline function |
| `Space rb` | Normal | Extract block |
| `Space rbf` | Normal | Extract block to file |

## Documentation

| Keybinding | Mode | Action |
|------------|------|--------|
| `Space dg` | Normal | Generate documentation (Google style) |

## Git Integration

| Keybinding | Mode | Action |
|------------|------|--------|
| `Space gg` | Normal | Open LazyGit |

## Editor Settings

### Display
- **Line numbers**: Relative line numbers enabled
- **Cursor line**: Highlighted
- **Scroll offset**: 10 lines above/below cursor
- **Color scheme**: Dark theme with true colors
- **Line wrapping**: Disabled

### Indentation
- **Tab size**: 4 spaces
- **Auto indent**: Enabled
- **Expand tabs**: Spaces instead of tabs

### Search
- **Ignore case**: Yes (smart case - case-sensitive if uppercase used)

### Clipboard
- **System clipboard**: Integrated (use `y` to yank to system clipboard)

### Splits
- **Split right**: Vertical splits open to the right
- **Split below**: Horizontal splits open below

---

## Tips & Tricks

1. **Seamless Tmux + Neovim Navigation**: Use `Ctrl+h/j/k/l` to navigate between both Neovim splits and Tmux panes without thinking about boundaries

2. **Quick File Access**: Use `Space ff` to quickly find any file in your project

3. **Fast Text Search**: Use `Space fs` to search for text across all files in your project

4. **Session Persistence**: Tmux sessions are automatically saved - your work survives computer restarts

5. **Quick Save**: Use `Space w` instead of `:w<Enter>` to save files faster

6. **Exit Insert Mode**: Use `jk` as a faster alternative to `Esc`

7. **Window Maximize**: Use `Space sm` in Neovim or `Ctrl+a m` in Tmux to temporarily maximize a pane/window

8. **LazyGit Integration**: Use `Space gg` for a beautiful terminal UI for Git operations

---

## Plugin List

### Tmux Plugins
- **TPM**: Tmux Plugin Manager
- **vim-tmux-navigator**: Seamless navigation between vim and tmux
- **tmux-themepack**: Theme support
- **tmux-resurrect**: Session persistence
- **tmux-continuum**: Automatic session saving

### Neovim Plugins (Core)
- **lazy.nvim**: Plugin manager
- **Telescope**: Fuzzy finder
- **NvimTree**: File explorer
- **LSP**: Language Server Protocol support
- **LSPSaga**: Enhanced LSP UI
- **LazyGit**: Git integration
- **Refactoring**: Code refactoring tools
- **nvim-cmp**: Autocompletion
- **autopairs**: Auto close brackets/quotes
- **vim-tmux-navigator**: Seamless tmux navigation

---

## Installation Quick Reference

After cloning the repo:

```bash
# Install with automated script (recommended)
bash <(curl -fsSL https://github.com/papy-ganjha/Dotfiles/raw/refs/heads/main/install.sh)

# Or manual install with stow
stow . --adopt -t $HOME

# Install tmux plugins
# In tmux: Ctrl+a then Shift+i

# Neovim plugins install automatically on first launch
nvim
```

## Troubleshooting

- **Tmux plugins not working**: Press `Ctrl+a` then `Shift+i` to install
- **Colors look wrong**: Make sure your terminal supports 256 colors
- **Neovim plugins missing**: Launch nvim and wait for lazy.nvim to install plugins
- **Navigation not working**: Ensure vim-tmux-navigator is installed in both Neovim and Tmux
