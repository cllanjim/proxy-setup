#!/bin/bash

function detect_os(){
if ([ -f  /usr/bin/uname ] || [ -f /system/bin/uname ]) && \
    ([ -x /usr/bin/uname ] || [ -x /system/bin/uname ]); then
    declare -r platform="$(uname -a)"
    declare -r platform_os="$(expr substr  "${platform}" 1 5)"
    printf "%s" "${platform_os}"
else
    printf "%s" "sorry, unsupport system"
fi
}
function get_kcptun(){
    if [ -f "/tmp/kcptun-linux*" ]; then
        rm "/tmp/kcptun-linux*"
    fi
    if [[ "$(detect_os)" == "Linux" ]] && [ -f /usr/bin/curl ]; then
    declare -r X86_64_URL="https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-linux-amd64-20181114.tar.gz"
    curl -L "${X86_64_URL}" -o "/tmp/kcptun-linux-amd64-20181114.tar.gz"
    elif [[ "$(detect_os)" == "Drawin" ]]; then
    declare -r Drawin_URL="https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-darwin-amd64-20181114.tar.gz"
    curl -L "${Drawin_URL}" -o "/tmp/kcptun-linux-amd64-20181114.tar.gz"
    else
        printf "%s" "Sorry, unsupport system"
    fi
}
function http_proxy(){

declare -r DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f $DIR/bin/privoxy  ] && [ -f $DIR/etc/privoxy/config  ] ; then
    printf "exec %s" "$DIR/bin/privoxy -c $DIR/etc/privoxy/config"
else
    printf "%s" "Can not found privoxy server and its configure files,Maybe you have broken installation"
fi
}
function setup_proxy(){
    sudo systemctl start privoxy.service
    ss-local ./configs/ss.conf &
    ./client_linux_amd64 -c ./configs/kcp.conf &
}
