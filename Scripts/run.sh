llvm() {
  local build=$1
  local program=$2
  shift 2
  $HOME/Projects/LLVM/llvm/build-$build/bin/$program $*
}

klee() {
  local build=$1
  local program=$2
  shift 2
  $HOME/Projects/klee/build-$build/bin/$program $*
}
