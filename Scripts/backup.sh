export GOMAXPROCS=4

./restic.sh backup -x --exclude-caches --exclude-file ./restic-exclude /home/jryans
