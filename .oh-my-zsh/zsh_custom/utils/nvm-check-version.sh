cd() {
  builtin cd "$@"
  if [ -f .nvmrc ];then
    {     
      nvm use
    }
  fi
}