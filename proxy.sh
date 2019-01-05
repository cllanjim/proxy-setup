#!/bin/bash
function detect_os(){
    platform="$(uname -a)"
}
function http_proxy(){

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f $DIR/bin/privoxy  ] && [ -f $DIR/etc/privoxy/config  ] ; then
    printf "exec %s" "$DIR/bin/privoxy -c $DIR/etc/privoxy/config"
else
    printf "%s" "Can not found privoxy server and its configure files,Maybe you have broken installation"
fi
}
function setup_proxy(){
    sudo systemctl start privoxy.service
    ss-local ./config.conf
    ./client_linux_amd64 -c kcp.conf
}
