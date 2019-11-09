cd() {
  builtin cd "$@"
  if [ -f .nvmrc ];then
    {
      local nvmrc_node_version=$(nvm version "$(cat .nvmrc)")
      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
      fi
    } &> /dev/null
  fi
}