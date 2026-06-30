## dockerfile

- Builds are now reproducible against that exact base. When you want a newer base (security patches), bump the digest — either via a Renovate/Dependabot PR or by re-running docker buildx imagetools 
  inspect ubuntu:26.04 and updating the line.

### TODO:


- 3. Prebuild + push to a registry, build once in CI. This is the real cure for the 5-min wait. Run devcontainer build --push (or a GitHub Action / devcontainer prebuild) so the export happens once on a
  CI runner. Devs then docker pull cached layers instead of rebuilding. You're already publishing features to ghcr.io/bbchk/pers/*, so the registry path is right there.

- 5. Make sure custom install scripts clean up in the same layer. The rocker-org/apt-packages feature cleans /var/lib/apt/lists/* for you, but your own feature scripts (neovim 246 MB, etc.) should rm -rf build artifacts / caches in the same RUN so they don't get frozen into the layer.

6. Single-arch builds. Don't build multi-arch (linux/amd64,linux/arm64) unless teammates are actually on both — it doubles export time.


- FIX: zsh compinit: insecure directories and files, run compaudit for list.
  1 Ignore insecure directories and files and continue [y] or abort compinit [n]?

- is it safe for our runner?

- speed up devcontainer creation

- fix clipboard in devcon
  `:lua print(vim.inspect(vim.g.clipboard))`


- source ros2 in postCreate

- If we scope devcontainers by langs and features, we need to scope nvim config somehow as well, so we don't get any install errors, etc.

- need C++ feature, see:
  https://github.com/devcontainer-community/devcontainer-features/tree/main/src/collection-c-cpp
  https://github.com/jakoch/cpp-devbox/tree/main
  https://github.com/microsoft/vscode-remote-try-cpp
  https://github.com/vitaliy-ostapchuk93/cpp-dev-sandbox
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

#6 — Single-arch builds ✅ (already satisfied — nothing to change)

I checked for any multi-arch build: there's no .github/workflows, no Makefile/bake file, and your devcon up commands in the README pass no --platform. Docker/the devcontainer CLI default to the host's single architecture, so you're not building amd64,arm64 anywhere today. There's no multi-arch build to remove.

The only place it will matter is the future CI prebuild (your README TODO #3). When you write that workflow, keep it to one platform:

devcontainer build --workspace-folder . --push --platform linux/amd64
# or buildx:  docker buildx build --platform linux/amd64 ...

i.e. just don't pass a comma-separated --platform linux/amd64,linux/arm64. I left a note here rather than fabricating a workflow file you don't have yet — want me to scaffold that prebuild GitHub Action (TODO #3) with single-arch baked in?

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


