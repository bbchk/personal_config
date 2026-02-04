# NVM lazy loading - defers loading until nvm/node/npm is actually used
export NVM_DIR="$HOME/.nvm"

# Lazy-load nvm
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # Add nvm binaries to PATH without loading nvm
  export PATH="$NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default 2>/dev/null || echo '')/bin:$PATH"
  
  _nvm_lazy_load() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  }
  
  nvm() {
    _nvm_lazy_load
    nvm "$@"
  }
  
  node() {
    _nvm_lazy_load
    node "$@"
  }
  
  npm() {
    _nvm_lazy_load
    npm "$@"
  }
  
  npx() {
    _nvm_lazy_load
    npx "$@"
  }
fi
