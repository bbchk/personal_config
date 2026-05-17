<div align="center" style="display: flex; flex-direction: column;">
<img src="xdg/pictures/default/main_gif.gif" width="200">
</div>

<h5 align="center">
  <div>
    <span>Dotfiles, scripts and secrets for my machine</span>
  </div>
</h5>

<br />

<h3 align="center">
  <div>
    <span>How it works</span>
  </div>
</h3>

To put it very simple, this single repo manages workstation state in the following way:

- **`dotfiles/`** — symlinked into `$HOME`. Contains `.config`, `.zsh`, etc. Changes here reflect immediately.
- **`secrets/`** — encrypted at rest via GPG clean/smudge git filters. Transparent: `git checkout` decrypts, `git add` encrypts. Holds SSH keys, k8s configs, KeePassXC db, system files.
- **`scripts/`** — daily-use utilities (VPN connect, tmux sessionizer, flameshot).
- **`config/`** — app configs not suitable for dotfiles or not yet persisted as dotfiles (keyd, browser extensions, etc.).
- **`setup/`** — idempotent bootstrap. `index.sh` orchestrates: install packages → symlink dotfiles & decrypt secrets → configure GNOME → relocate XDG dirs → set zsh as shell. Registers as GNOME autostart (kitty window on login).
- **`xdg/`** — XDG user directories (Desktop, Downloads, etc.) live here instead of `$HOME`, pointed via `xdg-user-dirs-update`.
