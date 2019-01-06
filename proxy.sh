#!/bin/bash

declare -r platform="$(uname -a)"
declare -r platform_os="$(expr substr  "${platform}" 1 5)"

function return_func(){
}


function detect_os(){
if ([ -f  /usr/bin/uname ] || [ -f /system/bin/uname ]) && \
    ([ -x /usr/bin/uname ] || [ -x /system/bin/uname ]); then
    
    if [[ "$platform_os" == "Linux" ]]; then
        printf "Your platform: %s\n" "$platform_os"
    elif [[ "$platform" == "Drawin" ]]; then
        printf "Your platform: %s\n" "$platform_os"
    else
        printf "%s" "Sorry can not detect your platform"
    fi
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

    ss-local ./ss.conf &
    ./client_linux_amd64 -c kcp.conf &
}
