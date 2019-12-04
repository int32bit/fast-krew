#!/bin/bash

get_index_path()
{
    INDEX_BASE=$(kubectl krew version | awk '/IndexPath/{print $2}')
    INDEX_PATH=$INDEX_BASE/plugins/$NAME.yaml
    echo "$INDEX_PATH"
}

get_plugin_url()
{
    NAME=$1
    URL=$(grep 'uri: ' "$INDEX_FILE" | grep -Po "https://.*" | grep -Pvi '(darwin)|(windows)|(linux.*386)|(linux.*arm)' | uniq)
    echo "$URL"
}

download_use_axel()
{
    NUM_CONN=$1
    URL=$2
    TARGET=$3
    BASE_NAME=$(basename "$URL")
    echo "axel -n $NUM_CONN -o $TARGET $URL"
    axel -n "$NUM_CONN" -o "$TARGET" "$URL"
}

install_plugin()
{
    INDEX_FILE=$1
    PLUGIN_FILE=$2
    echo "kubectl krew install --manifest=$INDEX_FILE --archive=$PLUGIN_FILE"
    kubectl krew install --manifest="$INDEX_FILE" --archive="$PLUGIN_FILE"
}

main()
{
    if [[ $1 == '-n' ]]; then
        shift
        NUM_CONN=$1
        shift
    else
        NUM_CONN=100
    fi
    NAME=$1
    if [[ -z $NAME ]]; then
        kubectl krew search
	exit 0
    fi
    if kubectl krew list | grep -q "$NAME"; then
        echo "Skipping plugin '$NAME', it is already installed"
        exit 0
    fi
    INDEX_FILE=$(get_index_path "$NAME")
    if [[ ! -f "$INDEX_FILE" ]]; then
    	echo "Failed to load plugin '${NAME}' from the index: open ${INDEX_FILE}: no such file or directory"
    	exit 1
    fi
    URL=$(get_plugin_url "$NAME")
    BASE_NAME=$(basename "$URL")
    TARGET=/tmp/"$BASE_NAME"
    download_use_axel "$NUM_CONN" "$URL" "$TARGET"
    install_plugin "$INDEX_FILE" "$TARGET"
    rm -rf "$TARGET"
}

main "$@"
