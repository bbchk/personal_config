# Compile zsh files for faster loading (run manually or on first load)
for config_file in ~/.zsh/*.zsh ~/.zsh/tools/*.zsh; do
  if [[ ! -f "${config_file}.zwc" ]] || [[ "$config_file" -nt "${config_file}.zwc" ]]; then
    zcompile "$config_file"
  fi
  source "$config_file"
done

export PATH="$PATH:/home/bchk/.local/bin"

# Benchmark your shell startup time
# time zsh -i -c exit

