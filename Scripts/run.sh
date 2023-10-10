llvm() {
  local build=$1
  local program=$2
  shift 2
  $HOME/Projects/LLVM/llvm/builds/$build/bin/$program "$@"
}

klee() {
  local build=$1
  local program=$2
  shift 2
  $HOME/Projects/klee/build-$build/bin/$program "$@"
}

csmith() {
  local build=$1
  local program=$2
  shift 2
  $HOME/Projects/csmith/build-$build/src/$program "$@"
}
