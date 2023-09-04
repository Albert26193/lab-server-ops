mytreedu() {
  local depth=''

  while getopts "L:" opt ; do
    case "$opt" in
      L) depth="$OPTARG" ;;
    esac
  done

  shift "$((OPTIND-1))"

  if [ -z "$depth" ] ; then
    tree --du -d -shaC "$@"
  else   
    local PATTERN='(  *[^ ]* ){'"$depth"'}\['
    tree --du -d -shaC "$@" | grep -Ev "$PATTERN"
  fi
}
