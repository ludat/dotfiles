use_nvm() {
  local node_version=$1

  nvm_sh=/usr/share/nvm/init-nvm.sh
  if [[ -e $nvm_sh ]]; then
    source $nvm_sh
    export DO_SOURCE="source \"$nvm_sh\""
    export DO_INSTALL="nvm install $node_version"
    export DO_USE="nvm use $node_version"
    eval "$DO_USE"
  fi
}
