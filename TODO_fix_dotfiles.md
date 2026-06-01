# Dotfiles GitHub security and portability review

**Session ID:** ses_17c454cf2ffecQc3DmcdjW3hps
**Created:** 6/1/2026, 10:08:31 AM
**Updated:** 6/1/2026, 10:18:51 AM

---

## User

Take a look at this dotfiles directory that I'd like to track on github, so that I can transfer my config and setups to another computer. Be very thorough and see
- are there any security risk if I commit these to github?
- any config or settings that cannot be transferred to a different computer

---

## Assistant (Plan · Claude Sonnet 4.6 · 84.1s)

_Thinking:_

Let me explore the dotfiles directory thoroughly to understand what's there.

**Tool: task**

**Input:**
```json
{
  "description": "Explore dotfiles directory",
  "prompt": "Explore the dotfiles directory at /Users/lchen5/codebase/dotfiles very thoroughly. List all files and their contents. I need to know:\n1. What files/configs are present\n2. Any files that might contain secrets, tokens, passwords, API keys, or sensitive credentials\n3. Any configs that contain machine-specific settings (absolute paths, hostnames, hardware identifiers, etc.) that wouldn't transfer to another computer\n\nPlease read as many files as possible and provide a comprehensive report with specific file paths and line numbers for any concerns found. Be thorough.",
  "subagent_type": "explore"
}
```

**Output:**
```
task_id: ses_17c45359bffetmiVkgg0Vz61xf (for resuming to continue this task if needed)

<task_result>
I now have a complete picture of all the meaningful files. Here is the comprehensive report:

---

# Dotfiles Directory — Comprehensive Report

## 1. Complete File Inventory

The repository has **two tiers of content**:
- **Core dotfiles** (the actual personal configs, tracked by git)
- **`.config/opencode/node_modules/`** — a massive vendored npm dependency tree (hundreds of third-party JS library files, all boilerplate, nothing sensitive)

### Root-level files

| File | Purpose |
|---|---|
| `.bashrc` | Bash shell config for non-login interactive shells |
| `.profile` | Bash login shell bootstrap; sources `.bashrc` |
| `.tmux.conf` | Tmux configuration (keybindings, theme, plugins) |
| `.vimrc` | Vim configuration (plugins via vim-plug, keybindings, settings) |
| `.gitignore_global` | Global gitignore patterns (Python, Vim, Linux, Windows, VSCode) |
| `README.md` | One-line repo description |
| `LICENSE` | License file |

### `.config/` subdirectory

| File | Purpose |
|---|---|
| `.config/fish/config.fish` | Fish shell interactive config (starship, brew, fzf, Antigravity path) |
| `.config/fish/fish_variables` | Fish universal variables (persistent PATH entries) |
| `.config/fish/conf.d/fnm.fish` | Auto-sources fnm (Node version manager) on each shell |
| `.config/fish/conf.d/pnpm.fish` | Sets `PNPM_HOME` and adds pnpm paths |
| `.config/fish/conf.d/fish_frozen_key_bindings.fish` | Fish 4.3 migration helper |
| `.config/fish/completions/cortex.fish` | Shell completions for Snowflake's `cortex` CLI tool |
| `.config/fish/completions/fnm.fish` | Shell completions for `fnm` |
| `.config/fish/completions/git.fish_OLD` | Disabled/old git completions override |
| `.config/fish/functions/setup_claude.fish` | Fish function to enable Claude Code via AWS Bedrock |
| `.config/fish/functions/clear_claude.fish` | Fish function to unset Claude/AWS env vars |
| `.config/ghostty/config` | Ghostty terminal emulator config (font, theme) |
| `.config/git/ignore` | Git global ignore (ignores `.claude/settings.local.json`) |
| `.config/opencode/opencode.json` | OpenCode AI agent configuration (multi-agent setup) |
| `.config/opencode/package.json` | OpenCode npm plugin dependency |
| `.config/opencode/.gitignore` | Ignores `node_modules`, `package.json`, `bun.lock`, `.gitignore` itself |

---

## 2. Secrets, Tokens, Passwords, API Keys — Findings

**No actual secret values (tokens, passwords, API keys) were found hardcoded in any file.** However, there are several **notable items** to be aware of:

### Hardcoded Path with Process/Session ID — `.vimrc` line 226
```vim
let g:coc_node_path = '/Users/lchen5/.local/state/fnm_multishells/25179_1761606572828/bin/node'
```
- **Severity: Medium concern.** This is not a secret, but it contains a **session-specific process ID** (`25179_1761606572828`) embedded in a path. This path will be stale/broken on any other machine or even after restarting fnm on the same machine. This should be replaced with a dynamic path (e.g., using `$(fnm which node)` or a symlink).

### AWS/Bedrock Environment Variable Setup — `.config/fish/functions/setup_claude.fish` lines 9–13
```fish
set -gx CLAUDE_CODE_USE_BEDROCK 1
set -gx AWS_REGION us-east-1
set -gx CLAUDE_CODE_MAX_OUTPUT_TOKENS 8192
set -gx MAX_THINKING_TOKENS 4096
set -gx AWS_PROFILE $profile
```
- **No secrets hardcoded here** — `AWS_PROFILE` is a profile name (defaults to `"development"`), not a key. The actual AWS credentials live in `~/.aws/credentials` which is not in this repo. This is the correct approach. Just be aware that deploying this function implies the target machine must have matching AWS profiles/credentials configured.

### `.config/git/ignore` — line 1
```
**/.claude/settings.local.json
```
- This intentionally prevents `.claude/settings.local.json` from ever being committed globally, which is a **good security practice** — it suggests those files may contain sensitive Claude/API settings that should stay local.

---

## 3. Machine-Specific Settings That Won't Transfer

These are configs with hardcoded values tied to this specific machine (`lchen5` on macOS):

### HIGH PRIORITY — Will break on another machine

| File | Line | Issue |
|---|---|---|
| `.vimrc` | **226** | `let g:coc_node_path = '/Users/lchen5/.local/state/fnm_multishells/25179_1761606572828/bin/node'` — Hardcoded absolute path with a transient session ID. Will definitely be a broken/wrong path everywhere else. |
| `.config/fish/fish_variables` | **4** | `SETUVAR fish_user_paths:/Users/lchen5/Library/pnpm/bin\x1e/Users/lchen5/Library/pnpm\x1e/Users/lchen5/.antigravity/...` — All PATH entries are hardcoded as `/Users/lchen5/...` absolute paths. These will silently do nothing on any other machine. |
| `.config/fish/conf.d/pnpm.fish` | **2** | `set -gx PNPM_HOME "/Users/lchen5/Library/pnpm"` — Hardcoded absolute path. Should use `$HOME` instead: `set -gx PNPM_HOME "$HOME/Library/pnpm"`. |
| `.config/fish/config.fish` | **22** | `fish_add_path /Users/lchen5/.antigravity/antigravity/bin` — Hardcoded absolute path for the "Antigravity" tool. Should be `$HOME/.antigravity/antigravity/bin`. |

### MEDIUM PRIORITY — macOS/Homebrew specific

| File | Line | Issue |
|---|---|---|
| `.config/fish/config.fish` | **14–16** | Checks for `/opt/homebrew/share/fish/vendor_completions.d/brew.fish` — This is the Apple Silicon Homebrew path. Will not exist on Intel Mac (`/usr/local/`) or Linux. |
| `.bashrc` | **31** | References `/usr/bin/lesspipe` — Linux-specific path, doesn't exist on macOS. |
| `.bashrc` | **76–85** | Uses `/usr/bin/dircolors` — Linux-specific (GNU coreutils). Not present on macOS by default. |
| `.bashrc` | **112–116** | Sources bash completions from `/usr/share/bash-completion/` or `/etc/bash_completion` — Linux paths. |
| `.tmux.conf` | **49, 51** | Uses `xclip` for clipboard integration — Linux-only tool. On macOS, `pbcopy`/`pbpaste` or `reattach-to-user-namespace` would be needed. |
| `.vimrc` | **215** | `let g:mkdp_browser = 'Google Chrome'` — Assumes Google Chrome is installed. |
| `.bashrc` | **123–134** | Conda init block references `/home/leichen/anaconda3/...` — a **different username** (`leichen` vs `lchen5`) and a Linux home path (`/home/` vs `/Users/`). This is commented out, but it reveals a legacy Linux machine identity. |

### LOW PRIORITY — Style/preference, but notable

| File | Line | Issue |
|---|---|---|
| `.vimrc` | **214** | `let g:mkdp_port = '8342'` — Specific port number for markdown preview server. Could conflict with other services. |
| `.config/opencode/opencode.json` | **7, 25, 43, 61, 79** | References model names like `github-copilot/claude-sonnet-4.5` — these require the `github-copilot` provider to be configured. Not portable unless the same provider/auth is set up. |

---

## Summary

- **No hardcoded secrets, API keys, or passwords** were found in any file.
- **The most critical portability issue** is `.vimrc` line 226: a hardcoded, session-ephemeral path for the CoC Node.js binary. It should use `$(fnm which node)` or a stable symlink.
- **Four files have hardcoded `/Users/lchen5/` absolute paths** that need to be converted to `$HOME`-relative references: `fish_variables` (line 4), `pnpm.fish` (line 2), `config.fish` (line 22), and `.vimrc` (line 226).
- **`.bashrc` is Linux-oriented** (references `/usr/bin/dircolors`, `lesspipe`, bash-completion paths, and even a commented-out legacy `/home/leichen/` conda path) while the machine is clearly macOS. This suggests `.bashrc` is a legacy carry-over that may not be actively used on this Mac.
- **`.tmux.conf` uses `xclip`** (lines 49–51), which is Linux-only and will silently fail on macOS.
</task_result>
```

---

## Assistant (Plan · Claude Sonnet 4.6 · 14.8s)

Here's a thorough analysis of your dotfiles:

---

## Security Risks

**Good news: no hardcoded secrets were found.** No API keys, passwords, or tokens are present.

Minor things to note:
- `.config/git/ignore` already excludes `.claude/settings.local.json` globally — good practice, suggests you know those may contain sensitive data.
- `.config/fish/functions/setup_claude.fish` sets `AWS_PROFILE` but not actual credentials — safe to commit.

---

## Portability Issues

### Critical — Will break on another machine

| File | Line | Issue |
|---|---|---|
| `.vimrc` | 226 | Hardcoded session-ephemeral path: `/Users/lchen5/.local/state/fnm_multishells/25179_1761606572828/bin/node` — wrong on every other shell session, let alone another machine. Should use `$(fnm which node)` or a stable symlink. |
| `.config/fish/fish_variables` | 4 | All `fish_user_paths` are hardcoded as `/Users/lchen5/...`. Will silently do nothing on another machine. |
| `.config/fish/conf.d/pnpm.fish` | 2 | `PNPM_HOME` hardcoded to `/Users/lchen5/Library/pnpm`. Should use `$HOME`. |
| `.config/fish/config.fish` | 22 | `fish_add_path /Users/lchen5/.antigravity/...` — hardcoded. Should use `$HOME`. |

### Medium — macOS/platform specific

| File | Issue |
|---|---|
| `.tmux.conf:49-51` | Uses `xclip` (Linux-only). macOS needs `pbcopy`/`pbpaste`. |
| `.bashrc:31,76-85,112-116` | References Linux paths (`/usr/bin/lesspipe`, `dircolors`, `/usr/share/bash-completion/`). Not present on macOS. |
| `.config/fish/config.fish:14-16` | Hardcoded Apple Silicon Homebrew path (`/opt/homebrew/`). Won't work on Intel Mac or Linux. |
| `.bashrc:123-134` | Commented-out conda block referencing a different username (`leichen`) and Linux home path (`/home/`). Legacy artifact. |

### Low — Preferences/assumptions

| File | Issue |
|---|---|
| `.vimrc:215` | Assumes Google Chrome is installed for markdown preview. |
| `.config/opencode/opencode.json` | References `github-copilot` provider — only works if that auth is configured. |

---

## Recommendations Before Committing

1. **Fix the 4 hardcoded `/Users/lchen5/` paths** → replace with `$HOME`
2. **Fix `.vimrc:226`** → remove or dynamically resolve the CoC node path
3. **Add a `.gitignore`** at the repo root to exclude `.config/opencode/node_modules/` (it shouldn't be tracked)
4. **Optionally**: add platform guards to `.tmux.conf` and `.bashrc` for cross-OS compatibility

The `.config/opencode/.gitignore` already ignores `node_modules` within that subdirectory, so that's covered — but worth verifying the root `.gitignore` handles it too.

Want me to implement these fixes?

---

## User

how about write detailed execution steps, and I can use ai agent to implement these fixes on the new computer?

---

## Assistant (Plan · Claude Sonnet 4.6 · 7.2s)

_Thinking:_

The user wants detailed execution steps written out so they can use an AI agent to implement fixes on a new computer. I need to read the relevant files to get exact content, then write precise instructions.

Let me read the specific files to write precise, actionable instructions.

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/lchen5/codebase/dotfiles/.vimrc",
  "offset": 220,
  "limit": 15
}
```

**Output:**
```
<path>/Users/lchen5/codebase/dotfiles/.vimrc</path>
<type>file</type>
<content>
220: let g:ale_linters = {'javascript': ['eslint']}
221: " Only run linters named in ale_linters settings.
222: let g:ale_linters_explicit = 1
223: 
224: " Conquer of Completion
225: Plug 'neoclide/coc.nvim', {'branch': 'release'}
226: let g:coc_node_path = '/Users/lchen5/.local/state/fnm_multishells/25179_1761606572828/bin/node'
227: " Use <cr> to confirm completion
228: inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"
229: " GoTo code navigation
230: nmap <silent> gd <Plug>(coc-definition)
231: nmap <silent> gy <Plug>(coc-type-definition)
232: nmap <silent> gi <Plug>(coc-implementation)
233: nmap <silent> gr <Plug>(coc-references)
234: 

(Showing lines 220-234 of 386. Use offset=235 to continue.)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/lchen5/codebase/dotfiles/.config/fish/conf.d/pnpm.fish"
}
```

**Output:**
```
<path>/Users/lchen5/codebase/dotfiles/.config/fish/conf.d/pnpm.fish</path>
<type>file</type>
<content>
1: # pnpm
2: set -gx PNPM_HOME "/Users/lchen5/Library/pnpm"
3: #if not string match -q -- $PNPM_HOME $PATH
4:   #set -gx PATH "$PNPM_HOME" $PATH
5: #end
6: fish_add_path $PNPM_HOME
7: fish_add_path $PNPM_HOME/bin

(End of file - total 7 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/lchen5/codebase/dotfiles/.config/fish/config.fish"
}
```

**Output:**
```
<path>/Users/lchen5/codebase/dotfiles/.config/fish/config.fish</path>
<type>file</type>
<content>
1: if status is-interactive
2:     # Commands to run in interactive sessions can go here
3: end
4: 
5: # starship
6: starship init fish | source
7: 
8: # fnm
9: #eval "$(fnm env)"
10: 
11: # brew
12: set -gx HOMEBREW_CASK_OPTS "--appdir=$HOME/Applications"
13: # Force load brew completions
14: if test -f /opt/homebrew/share/fish/vendor_completions.d/brew.fish
15:     source /opt/homebrew/share/fish/vendor_completions.d/brew.fish
16: end
17: 
18: # fzf
19: fzf --fish | source
20: 
21: # Added by Antigravity
22: fish_add_path /Users/lchen5/.antigravity/antigravity/bin

(End of file - total 22 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/lchen5/codebase/dotfiles/.config/fish/fish_variables"
}
```

**Output:**
```
<path>/Users/lchen5/codebase/dotfiles/.config/fish/fish_variables</path>
<type>file</type>
<content>
1: # This file contains fish universal variable definitions.
2: # VERSION: 3.0
3: SETUVAR __fish_initialized:4300
4: SETUVAR fish_user_paths:/Users/lchen5/Library/pnpm/bin\x1e/Users/lchen5/Library/pnpm\x1e/Users/lchen5/\x2eantigravity/antigravity/bin\x1e/opt/homebrew/bin\x1e/Users/lchen5/\x2elocal/bin

(End of file - total 4 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/lchen5/codebase/dotfiles/.tmux.conf",
  "offset": 44,
  "limit": 15
}
```

**Output:**
```
<path>/Users/lchen5/codebase/dotfiles/.tmux.conf</path>
<type>file</type>
<content>
44: bind-key -n M-Down select-pane -D
45: bind-key -n M-Right select-pane -R
46: 
47: # For binding 'y' to copy and exiting selection mode
48: # and use xclip to save copied content
49: bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -sel clip -i'
50: # For binding 'Enter' to copy and not leave selection mode
51: bind-key -T copy-mode-vi Enter send-keys -X copy-pipe 'xclip -sel clip -i' '\;'  send -X clear-selection
52: 
53: # -----------------------------------------------------------------------------
54: # DESIGN CHANGES
55: # -----------------------------------------------------------------------------
56: 
57: # loud or quiet?
58: set -g visual-activity off

(Showing lines 44-58 of 116. Use offset=59 to continue.)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/lchen5/codebase/dotfiles/.gitignore_global"
}
```

**Output:**
```
<path>/Users/lchen5/codebase/dotfiles/.gitignore_global</path>
<type>file</type>
<content>
1: ### Python ###
2: # Byte-compiled / optimized / DLL files
3: __pycache__/
4: *.py[cod]
5: *$py.class
6: 
7: ### Vim ###
8: # Swap
9: [._]*.s[a-v][a-z]
10: !*.svg  # comment out if you don't need vector files
11: [._]*.sw[a-p]
12: [._]s[a-rt-v][a-z]
13: [._]ss[a-gi-z]
14: [._]sw[a-p]
15: 
16: # Session
17: Session.vim
18: Sessionx.vim
19: 
20: # Temporary
21: .netrwhist
22: *~
23: # Auto-generated tag files
24: tags
25: # Persistent undo
26: [._]*.un~
27: 
28: ### Linux ###
29: *~
30: 
31: # temporary files which can be created if a process still has a handle open of a deleted file
32: .fuse_hidden*
33: 
34: # KDE directory preferences
35: .directory
36: 
37: # Linux trash folder which might appear on any partition or disk
38: .Trash-*
39: 
40: # .nfs files are created when an open file is removed but is still being accessed
41: .nfs*
42: 
43: ### vscode ###
44: .vscode/*
45: !.vscode/settings.json
46: !.vscode/tasks.json
47: !.vscode/launch.json
48: !.vscode/extensions.json
49: *.code-workspace
50: 
51: ### Windows ###
52: # Windows thumbnail cache files
53: Thumbs.db
54: Thumbs.db:encryptable
55: ehthumbs.db
56: ehthumbs_vista.db
57: 
58: # Dump file
59: *.stackdump
60: 
61: # Folder config file
62: [Dd]esktop.ini
63: 
64: # Recycle Bin used on file shares
65: $RECYCLE.BIN/
66: 
67: # Windows Installer files
68: *.cab
69: *.msi
70: *.msix
71: *.msm
72: *.msp
73: 
74: # Windows shortcuts
75: *.lnk

(End of file - total 75 lines)
</content>
```

---

## Assistant (Plan · Claude Sonnet 4.6 · 27.3s)

Here are the detailed execution steps, ready to hand off to an AI agent:

---

## Dotfiles Fix — Execution Steps

### Step 1 — Fix `.vimrc`: Remove hardcoded CoC node path

**File:** `.vimrc`, line 226

**Action:** Delete the hardcoded line entirely. CoC will auto-detect the node binary from `PATH`. If it can't, the user can set it correctly after installing fnm on the new machine.

Replace:
```vim
let g:coc_node_path = '/Users/lchen5/.local/state/fnm_multishells/25179_1761606572828/bin/node'
```
With: *(delete the line entirely)*

---

### Step 2 — Fix `.config/fish/conf.d/pnpm.fish`: Use `$HOME` instead of absolute path

**File:** `.config/fish/conf.d/pnpm.fish`, line 2

Replace:
```fish
set -gx PNPM_HOME "/Users/lchen5/Library/pnpm"
```
With:
```fish
set -gx PNPM_HOME "$HOME/Library/pnpm"
```

---

### Step 3 — Fix `.config/fish/config.fish`: Use `$HOME` for Antigravity path

**File:** `.config/fish/config.fish`, line 22

Replace:
```fish
fish_add_path /Users/lchen5/.antigravity/antigravity/bin
```
With:
```fish
fish_add_path $HOME/.antigravity/antigravity/bin
```

---

### Step 4 — Fix `.config/fish/config.fish`: Guard Homebrew completions for portability

**File:** `.config/fish/config.fish`, lines 13–16

The current code only checks the Apple Silicon Homebrew path. Replace with a version that works on Intel Mac and Linux too:

Replace:
```fish
# Force load brew completions
if test -f /opt/homebrew/share/fish/vendor_completions.d/brew.fish
    source /opt/homebrew/share/fish/vendor_completions.d/brew.fish
end
```
With:
```fish
# Force load brew completions (works on Apple Silicon, Intel Mac, and Linux)
for brew_completions in /opt/homebrew/share/fish/vendor_completions.d/brew.fish \
                        /usr/local/share/fish/vendor_completions.d/brew.fish \
                        /home/linuxbrew/.linuxbrew/share/fish/vendor_completions.d/brew.fish
    if test -f $brew_completions
        source $brew_completions
        break
    end
end
```

---

### Step 5 — Fix `.config/fish/fish_variables`: Reset `fish_user_paths`

**File:** `.config/fish/fish_variables`, line 4

This file is managed by Fish itself and stores universal variables in a machine-specific binary-ish format with hardcoded `/Users/lchen5/` paths. **Do not manually edit this file.**

Instead, on the new machine after cloning dotfiles, run these Fish shell commands to rebuild `fish_user_paths` cleanly:

```fish
set -U fish_user_paths   # clear all entries
fish_add_path $HOME/Library/pnpm/bin
fish_add_path $HOME/Library/pnpm
fish_add_path $HOME/.antigravity/antigravity/bin
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.local/bin
```

> **Note:** Because `fish_variables` is machine-managed, the recommended approach is to add it to `.gitignore` (see Step 7) and let these commands regenerate it fresh on each machine.

---

### Step 6 — Fix `.tmux.conf`: Make clipboard work on both macOS and Linux

**File:** `.tmux.conf`, lines 49–51

Replace:
```tmux
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -sel clip -i'
# For binding 'Enter' to copy and not leave selection mode
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe 'xclip -sel clip -i' '\;'  send -X clear-selection
```
With:
```tmux
# Clipboard: use pbcopy on macOS, xclip on Linux
if-shell "uname | grep -q Darwin" {
    bind-key -T copy-mode-vi y     send-keys -X copy-pipe-and-cancel 'pbcopy'
    bind-key -T copy-mode-vi Enter send-keys -X copy-pipe 'pbcopy' \; send -X clear-selection
} {
    bind-key -T copy-mode-vi y     send-keys -X copy-pipe-and-cancel 'xclip -sel clip -i'
    bind-key -T copy-mode-vi Enter send-keys -X copy-pipe 'xclip -sel clip -i' \; send -X clear-selection
}
```

---

### Step 7 — Add `fish_variables` to `.gitignore`

**File:** `.gitignore_global` (or create a `.gitignore` at the repo root if one doesn't exist)

Append the following line:
```
.config/fish/fish_variables
```

This prevents the machine-specific `fish_variables` file from being committed and conflicting across machines.

---

### Step 8 — Verify `node_modules` is excluded

**File:** `.config/opencode/.gitignore` already excludes `node_modules`. Confirm the repo root also has this covered by checking `git status` after applying all changes — there should be no `node_modules/` files staged.

---

## Summary Table

| Step | File | Type of Fix |
|---|---|---|
| 1 | `.vimrc:226` | Delete session-specific path |
| 2 | `conf.d/pnpm.fish:2` | `$HOME` substitution |
| 3 | `config.fish:22` | `$HOME` substitution |
| 4 | `config.fish:13-16` | Cross-platform Homebrew guard |
| 5 | `fish_variables:4` | Gitignore + re-run commands on new machine |
| 6 | `.tmux.conf:49-51` | macOS/Linux clipboard guard |
| 7 | `.gitignore_global` | Exclude `fish_variables` |
| 8 | (verify) | Confirm `node_modules` not tracked |

---

