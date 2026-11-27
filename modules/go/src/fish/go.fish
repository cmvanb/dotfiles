set -x GOPATH $XDG_DATA_HOME/go
set -x GOMODCACHE $XDG_CACHE_HOME/go/mod
fish_add_path -pP $GOPATH/bin
