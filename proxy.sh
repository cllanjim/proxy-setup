#!/bin/bash
function detect_os(){
    platform="$(uname -a)"
}

function http_proxy(){

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f $DIR/$DIR/bin/privoxy  ] && [ -f $DIR/etc/privoxy/config  ] ; then
    printf "exec %s" "$DIR/bin/privoxy -c $DIR/etc/privoxy/config"
else
    printf "%s" "Can not found privoxy server and its configure files,Maybe you have broken installation"
fi
}
