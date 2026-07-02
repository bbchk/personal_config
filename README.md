<div align="center" style="display: flex; flex-direction: column;">
<img src="xdg/Pictures/personal_configuration_repo.gif" width="200">
</div>

<h1 align="center">
  <div>
    <span>Dotfiles, scripts and secrets for my machine</span>
  </div>
</h1>

<br />

<h3 align="center">
  <div>
    <span>How it works</span>
  </div>
</h3>

To put it very simple, this single repo manages workstation state in the following way:

- **`dotfiles/`** — symlinked into `$HOME`. Contains all the dotfiles (e.g. `.config`, `.zsh`, etc.)
- **`dotfiles/.custom/`** — specific configs that cannot by symlinked.
- **`scripts/`** — daily-use utilities (VPN connect, devcontainer sessionizer, flameshot).
- **`scripts/setup/`** — workstation bootstrap scripts. Install packages → symlink dotfiles & decrypt secrets → configure GNOME → relocate XDG dirs. 
- **`xdg/`** — XDG user directories (Desktop, Downloads, etc.) live here instead of `$HOME`.
