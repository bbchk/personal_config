
git remote get-url origin

```bash
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
```

```bash
 ╰$ find './lws' -mindepth 1 -maxdepth 1 -type d -exec git -C {} remote get-url origin \;    
git@gitlab.com:liveworld/odoo.git
git@gitlab.com:liveworld/base-distro.git
git@gitlab.com:liveworld/cert_manager.git
git@gitlab.com:liveworld/ci_cd.git
git@gitlab.com:liveworld/docker.git
```


```bash
for url in $(find '../lws' -mindepth 1 -maxdepth 1 -type d -exec git -C {} remote get-url origin \;); do
  git submodule add "$url"
done
```

convert dev/my and dev/ib to repositories with submodules and include .gitconfig-ib that would set my username and email
collect all the projects I have atm in dev/my and dev/ib and write to pers/setup/common/filesystem.sh

run my local model that will check pre-commit if there are any sensitive files planned to commited that has any sensitive info (secrets)

git push --force-with-lease vs --force

implement quick shorcut for sessionizer to go to previous project

create shortcuts fro vs code!

in filters, would it help if we hash content? (limit size )



# .gitattributes
server/etc/profile.d/first-boot.sh filter=gpg
worker/etc/profile.d/first-boot.sh filter=gpg
ca.conf filter=gpg
*.key filter=gpg
*.crt filter=gpg
*kubeconfig filter=gpg
server/root/encryption-config.yaml filter=gpg
TODO.md filter=gpg

post-hoook apparntely checks only full paths, and errros out on globs and regexes
 ╰$ g ci -m 'feat'

  ⚙  pre-commit
  🔐 GPG filters active — secrets will be encrypted automatically.


  ⚙  post-commit  verifying encryption...
     ✓ TODO.md
     ✓ server/etc/profile.d/first-boot.sh
     ✓ worker/etc/profile.d/first-boot.sh
  ✓ all secrets encrypted
