# home_config

Personal dotfiles managed as repo-backed source fragments.

This repo keeps home configuration files in a structured layout and provides an installer that:

- symlinks repo files into `$HOME/.home_config/`
- adds a small managed source block to your real home files (for example `$HOME/.vimrc`)

The installer is safe by default (dry-run) and only writes changes when you pass `--apply`.

## Components

| Component | Description |
|-----------|-------------|
| `bash`    | Shell config (`.bashrc`) |
| `vim`     | Vim config (`.vimrc`) |
| `vi`      | Reduced `vi` config (`.virc`), option/mapping subset of the vim config |
| `neovim`  | Neovim config (`init.vim`), mirrors the vim config |
| `tmux`    | tmux config (`.tmux.conf`) |
| `copilot` | GitHub Copilot customization (`.copilot/`) |
| `omp`     | oh-my-pi (`omp`) config (`~/.omp/agent/`), modeled on the copilot config |
| `ghostty` | Ghostty terminal config (`~/.config/ghostty/`) |

## Installer

Installer: `install.sh`

Behavior:

1. Creates `$HOME/.home_config` if missing.
2. For each managed file, creates a symlink in `$HOME/.home_config/` pointing back to this repo.
3. Ensures your home file includes a managed block that sources the linked file.
4. If a target file already exists and is not a symlink, creates a timestamped backup before replacing.

Managed block markers look like this (example):

```bash
# >>> home_config managed .bashrc >>>
source "$HOME/.home_config/.bashrc"
# <<< home_config managed .bashrc <<<
```

## Usage

Dry-run (default, no changes written):

```bash
./install.sh
```

Apply changes:

```bash
./install.sh --apply
```

Install only specific components:

```bash
./install.sh --apply --only bash,copilot
./install.sh --only vim,tmux          # dry-run only vim + tmux
./install.sh --only bash --only vim   # repeated flag also works
```

Help:

```bash
./install.sh --help
```

## After Applying

- Bash: open a new shell, or run `source ~/.bashrc`
- tmux: run `tmux source-file ~/.tmux.conf`
- Vim: restart Vim
- Vi: restart vi (config: `~/.virc`)
- Neovim: restart nvim (config: `~/.config/nvim/init.vim`)
- omp: restart omp (config under `~/.omp/agent/`)
- Ghostty: restart Ghostty, or press `cmd+shift+,` to reload (config: `~/.config/ghostty/config`)

## Idempotency

Re-running the installer is expected and safe:

- existing correct symlinks are skipped
- existing managed source blocks are not duplicated
