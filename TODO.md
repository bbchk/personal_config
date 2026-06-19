## Tasks 

P1

move .ssh secrets to dotfiles 

create dev container setups for each development purpose (java, ros, c++, js, web, etc.)
Or better, use a Dev Container setup (VS Code or Neovim) where:

<!-- https://github.com/s1n7ax/nvim-search-and-replace -->

so we could use sessionizer that would spin up devcontainer in neovim in a chosen folder, instead of plain nvim

<!-- { -->
<!--     "name": "Java Container", -->
<!--     "image": "ubuntu:latest", -->
<!--     "features": { -->
<!--         "ghcr.io/s1n7ax/devcontainer-features/jdk19:0": {}, -->
<!--         "ghcr.io/s1n7ax/devcontainer-features/gradle:0": {}, -->
<!--         "ghcr.io/s1n7ax/devcontainer-features/maven:0": {}, -->
<!--         "ghcr.io/s1n7ax/devcontainer-features/neovim-essentials:0": {}, -->
<!--         "ghcr.io/s1n7ax/devcontainer-features/neovim:0": {}, -->
<!--         "ghcr.io/s1n7ax/devcontainer-features/astronvim:0": {} -->
<!--     } -->
<!-- } -->

<!--         "ghcr.io/s1n7ax/devcontainer-features/astronvim:0": {} --> I need to figure out what is and how build my ones

we need somehow to have defualt devcontainer container definition, so if I don't choose 

also I would like to have fzf for devcontainers on which I want to open a particular project? or is it easier to just have a devcontaainers.json file on each pj I work on? copying them will be boresome


is it worth to install many versions of languages inside a container (let's say java dev container and we install 20, 21, 25, etc.), so we don't need to switch beetween them. What is downside of such approach? -> weight of container, but I don't see an issue with this.

<!--     "image": "ubuntu:latest", -->it's better not use latest, it's better to pin up to patch version ubuntu:24.0.4, so it's 99.9% reproducible



Option 3: Multi-Folder Workspace Devcontainer
If all your projects live under one parent folder, you can open that parent folder in VS Code and define a single .devcontainer at the top level. All projects share one container.

```
workspace/
├── .devcontainer/
│   └── devcontainer.json
├── project-a/
├── project-b/
└── project-c/
```

<!-- !"dotfiles.repository": "https://github.com/your-username/dotfiles" -->

we should design our devcontainer wihtout neovim as a must, but as an additional packages (what do u think?)

----

practice debugger in nvim 
practice copilot.nvim
