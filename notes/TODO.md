
 ╰$ find './lws' -mindepth 1 -maxdepth 1 -type d -exec git -C {} remote -v \;
origin  git@gitlab.com:liveworld/odoo.git (fetch)
origin  git@gitlab.com:liveworld/odoo.git (push)
origin  git@gitlab.com:liveworld/base-distro.git (fetch)
origin  git@gitlab.com:liveworld/base-distro.git (push)
origin  git@gitlab.com:liveworld/cert_manager.git (fetch)
origin  git@gitlab.com:liveworld/cert_manager.git (push)
origin  git@gitlab.com:liveworld/ci_cd.git (fetch)
origin  git@gitlab.com:liveworld/ci_cd.git (push)
origin  git@gitlab.com:liveworld/docker.git (fetch)
origin  git@gitlab.com:liveworld/docker.git (push)

convert dev/my and dev/ib to repositories with submodules
collect all the projects I have atm in dev/my and dev/ib and write to pers/setup/common/filesystem.sh
