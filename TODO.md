## Tasks 

P1
support and highlighting of C++ and C in neovim
consider using -sb by default in git status = ╰$ git status -sb                                           
figure out how we can use copilot.nvim
figure out how we should use debugger in nvim 


create dev container setups for each development purpose (java, ros, c++, js, web, etc.)
Or better, use a Dev Container setup (VS Code or Neovim) where:



**clangd:**

It needs a `compile_commands.json` at the project root so it knows your include paths, flags, etc. For CMake projects (like ROS2):
```bash
# when building, cmake generates it automatically with this flag:
colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# then symlink it to the project root so clangd finds it:
ln -sf build/my_cpp_pkg/compile_commands.json compile_commands.json
```

For non-CMake projects, use `bear` to generate it:
```bash
sudo dnf install bear
bear -- make        # wraps your build command and captures it
```

Without `compile_commands.json`, clangd still works but will miss includes, show false errors on any `#include`, and have no understanding of your build flags.
