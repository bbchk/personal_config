### TODO:

- instead of mouning one folder, we should mount ~/dev, when on meta+f we are able to choose from different decontainer.json files stored ~/pers/devcon

- speed up devcontainer creation

- fix clipboard in devcon
  `:lua print(vim.inspect(vim.g.clipboard))`

- fzf for devcontainer.json files, when mounting whole dev/

- need C++ feature, see:
  https://github.com/devcontainer-community/devcontainer-features/tree/main/src/collection-c-cpp
  https://github.com/jakoch/cpp-devbox/tree/main
  https://github.com/microsoft/vscode-remote-try-cpp
  https://github.com/vitaliy-ostapchuk93/cpp-dev-sandbox

- each devcon image takes ~5gb, image is created for each folder, even though it's same, we can use ~/ as workspace

- source ros2 in postCreate

```
{
    "name": "collection-c-cpp",
    "id": "collection-c-cpp",
    "version": "1.0.3",
    "description": "C/C++ dev collection \u2014 cmake, ninja, gdb, valgrind, ccache, cppcheck, clang-format, clang-tidy, distcc, vcpkg, build-essential",
    "documentationURL": "https://github.com/devcontainer-community/devcontainer-features/tree/main/src/collection-c-cpp",
    "dependsOn": {
        "ghcr.io/devcontainer-community/devcontainer-features/cmake.org:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/ninja-build.org:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/sourceware.org-gdb:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/valgrind.org:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/ccache.dev:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/danmar-cppcheck:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/clang-format:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/clang-tidy:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/distcc.org:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/vcpkg.io:latest": {},
        "ghcr.io/devcontainer-community/devcontainer-features/apt-build-essential:latest": {}
    },
    "installsAfter": [
        "ghcr.io/devcontainer-community/devcontainer-features/ca-certificates:latest"
    ]
}
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

`devcontainer read-configuration --workspace-folder $PWD --include-merged-configuration | jq`

`gpg --export --armor E78A0D774F0BDAC50F897DC5FF99608021A353C0 > ~/.gnupg/devcon-public.asc`
