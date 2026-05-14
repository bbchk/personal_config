we need to get rid of ssh keys problem also problem of reencrypting with di
- I would like to have better markdown coloring in neovim

- create a hook that will automatically append PORT-<number>, PLTF-<number>, DF-<number>, HOP-<number> to each commit msg, if branch has that in name 

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

Thought for a few seconds
Smart idea. The concept: hash the plaintext input, compare to a cached hash, and if unchanged, output the previous ciphertext instead of re-encrypting. This would:

Solve the dirty working tree problem — same plaintext → same ciphertext output → git sees no change
Save bandwidth — no pointless re-encryption diffs pushed to remote
Here's how it would work:

pg-clean (stdin) →
  1. Read stdin into temp buffer
  2. Hash the plaintext (sha256)
  3. Check cache: ~/.cache/gpg-clean/<hash-of-filepath>
     - If cached hash matches → output cached ciphertext
     - If different → encrypt, store new hash + ciphertext in cache

use git hash-object to check if the blob already exists:

HASH=$(sha256sum | cut -d' ' -f1)
CACHE_FILE="$CACHE_DIR/$HASH"
if [ -f "$CACHE_FILE" ]; then
    cat "$CACHE_FILE"
else
    tee "$CACHE_FILE" | gpg --batch --yes --quiet -e --armor -r "$GPG_KEY_ID"
    # wait, this won't work — need to encrypt the original, not the tee
fi

Practical implementation
Want me to build it? The cleanest version would be:

gpg-clean reads stdin, hashes it
Checks ~/.cache/gpg-clean-cache/ for a file named by that hash
Cache hit → output the cached ciphertext verbatim
Cache miss → encrypt, tee the ciphertext to cache, output it
This fully solves the dirty tree problem and saves bandwidth. The only tradeoff is cached ciphertext on disk. Want me to implement it?
