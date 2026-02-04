# ------------------------------
# Ruby config 
# ------------------------------

export PATH="$HOME/.rbenv/bin:$PATH"

if (( $+commands[rbenv] )); then
  _rbenv_lazy_load() {
    eval "$(rbenv init - zsh)"
    unfunction _rbenv_lazy_load
  }
  rbenv() {
    _rbenv_lazy_load
    rbenv "$@"
  }
fi
# gem install ruby-lsp

#https://stackoverflow.com/questions/64860931/why-cant-rbenv-install-the-latest-ruby-version-on-ubuntu
#You can upgrade your system ruby-build (but the packages seem a bit behind) or just like you did clone the git repo as a plugin into your rbenv directory: git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
# However, you will need to keep your ruby-build clone up to date if you want to keep up with new ruby releases: git -C "$(rbenv root)"/plugins/ruby-build pull
