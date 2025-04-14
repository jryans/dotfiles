SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

export GOMAXPROCS=4

"${SCRIPT_DIR}/restic.sh" \
  backup \
  -x \
  --exclude-caches \
  --exclude-file "${SCRIPT_DIR}/restic-exclude" \
  ${HOME}
