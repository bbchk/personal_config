TODO:
- need our own lua feature or use some
- make clipboard work in the dev container
- need C++ feature, see:
https://github.com/devcontainer-community/devcontainer-features/tree/main/src/collection-c-cpp
https://github.com/devcontainer-community/devcontainer-features/tree/main/src/collection-c-cpp
- need ros2 feature
- implement gpg agent "warmpu" on startup script. 
```bash
Copy code
echo "test" | gpg --batch -e -r E78A0D774F0BDAC50F897DC5FF99608021A353C0 | gpg --batch -d >/dev/null
```


:lua print(vim.inspect(vim.g.clipboard))

git config --global --add safe.directory /workspaces/<dir>

> NB!: If all your projects live under one parent folder, you can open that parent folder in VS Code and define a single .devcontainer at the top level. All projects share one container.
```
workspace/
├── .devcontainer/
│   └── devcontainer.json
├── project-a/
├── project-b/
└── project-c/
```

### Useful commands

```
  devcon up \
  --workspace-folder $PWD \
  --remove-existing-container \
  --log-level trace \
  --no-lockfile \
  --dotfiles-repository "https://github.com/bbchk/personal_config.git" \
  --dotfiles-target-path "~/pers" \
  --dotfiles-install-command "/root/pers/scripts/setup/devcon.sh" \
  --mount "type=bind,source=${HOME}/.gnupg/private-keys-v1.d/3F8B20FBE0ED2DC0ECD533D56661CE64D7E8A8F2.key,target=/root/.gnupg/private-keys-v1.d/3F8B20FBE0ED2DC0ECD533D56661CE64D7E8A8F2.key" \
  --mount "type=bind,source=${HOME}/.gnupg/private-keys-v1.d/FA5DE4470687D6D2ABBB530C4E56172E13A38854.key,target=/root/.gnupg/private-keys-v1.d/FA5DE4470687D6D2ABBB530C4E56172E13A38854.key" \
  --mount "type=bind,source=${HOME}/.gnupg/devcon-public.asc,target=/root/.gnupg/devcon-public.asc"
```

```
  devcon up \
  --workspace-folder $PWD \
  --remove-existing-container \
  --log-level trace \
  --no-lockfile
```

devcontainer read-configuration --workspace-folder $PWD --include-merged-configuration | jq

gpg --export --armor E78A0D774F0BDAC50F897DC5FF99608021A353C0 > ~/.gnupg/devcon-public.asc
