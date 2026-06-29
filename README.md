# ernman_config

Personal dotfiles, cracked out, managed as repo-backed source fragments.

This repo keeps your `$HOME` config files in a structured layout and ships an installer that:

- symlinks repo files into `$HOME/.ernman_config/`
- splices a small managed source block into your real home files (for example `$HOME/.vimrc`) so the originals stay yours

The installer is safe by default (dry-run) and only writes anything when you pass `--apply`. It will not eat your dotfiles. Anything in the way gets a timestamped backup before it links over the top, like a considerate house guest who also alphabetizes your spice rack.

## Components

| Component | Description |
|-----------|-------------|
| `bash`    | Shell config (`.bashrc`) with a ridiculous amount of aliases |
| `vim`     | Superior Vim config (`.vimrc`) |
| `vi`      | Reduced `vi` config (`.virc`), as close as it can get to vim config |
| `neovim`  | Neovim config (`init.vim`), mirrors the vim config |
| `vscode`  | VS Code theme extension (`~/.vscode/extensions/`) |
| `zed`     | Zed theme files (`~/.config/zed/themes/`) |
| `tmux`    | tmux config (`.tmux.conf`) |
| `copilot` | GitHub Copilot customization (`.copilot/`) |
| `omp`     | oh-my-pi (`omp`) config (`~/.omp/agent/`), modeled loosley on the copilot config |
| `ghostty` | Ghostty terminal config (`~/.config/ghostty/`), translucent and shader-pilled |

## Installer

Installer: `install.sh`

What it does, in the order it does it:

1. Creates `$HOME/.ernman_config` if missing.
2. For each managed file, creates a symlink in `$HOME/.ernman_config/` pointing back to this repo.
3. Ensures your home file includes a managed block that sources the linked file.
4. If a target file already exists and is not a symlink, creates a timestamped backup before replacing. Past you is thereby forgiven.

Managed block markers look like this (do not edit between the lines unless you enjoy surprises):

```bash
# >>> ernman_config managed .bashrc >>>
source "$HOME/.ernman_config/.bashrc"
# <<< ernman_config managed .bashrc <<<
```

## Usage

Dry-run (the default, changes nothing, judges nothing):

```bash
./install.sh
```

Apply changes (the brave option):

```bash
./install.sh --apply
```

Install only specific components:

```bash
./install.sh --apply --only bash,copilot
./install.sh --only vim,tmux          # dry-run only vim + tmux
./install.sh --only bash --only vim   # repeated flag also works
```

Help, for when all of the above was somehow not enough:

```bash
./install.sh --help
```

## After Applying

- Bash: open a new shell, or run `source ~/.bashrc`
- VS Code: select `Ernman Cracked Purple` via `Preferences: Color Theme`
- Zed: select `Ernman Cracked Purple` in the theme picker
- tmux: run `tmux source-file ~/.tmux.conf` to reload bindings and the purple theme refresh
- Vim: restart Vim
- Vi: restart vi (config: `~/.virc`)
- Neovim: restart nvim (config: `~/.config/nvim/init.vim`)
- omp: restart omp (config under `~/.omp/agent/`)
- Ghostty: restart Ghostty, or press `cmd+shift+,` to reload (config: `~/.config/ghostty/config`)

## Idempotency

Re-running the installer is expected, safe and frankly encouraged:

- existing correct symlinks are skipped without ceremony
- existing managed source blocks are not duplicated, so mashing `--apply` repeatedly does nothing exciting
