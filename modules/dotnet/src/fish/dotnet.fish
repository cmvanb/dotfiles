set -x DOTNET_CLI_HOME $XDG_DATA_HOME/dotnet
set -x NUGET_PACKAGES $XDG_CACHE_HOME/nuget/packages
fish_add_path -pP $DOTNET_CLI_HOME/.dotnet/tools
