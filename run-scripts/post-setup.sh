git_root() {
  cd /
  sh -c 'echo "/dockerstation\n/proc/\n/sys/\n/dev\n/tmp\n/var/tmp/\n/home\n/run" >> .gitignore'
  git init
  git add -A
  git config  user.email "velcrine@gmail.com"
  git config  user.name "velcrine"
  git commit -am "initial" 1>/dev/null
}

case "${1}" in

"git")
  if [ "$2" == 'true' ]; then
  git_root
  fi
  ;;
*)
  echo "$0 [ git | ]"
  exit 1
  ;;
esac