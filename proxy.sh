#!/bin/bash
# exit code:
# exit 3 --  http_proxy fail
# exit 2 -- get_kcptun
# exit 1 -- unsupport system

function setup_help(){
cat <<EOF

Run "setup_help" for get help

Invoke "source ./proxy.sh" from your shell to add the following functions to your environment:
- detect_os :   detect your platform
- get_kcptun:   get kcptun binary from github release
- http_proxy:   deploy socks5 and http proxy
- setup_help:   display help
Environment options:
Look at the source to view more functions:
Github:https://github.com/ihexon/proxy-setup


EOF
}

function detect_os(){
local help_detect_os(){
printf "%s" "detect_os -- display system info"
cat <<EOF

--help      get help
--all       get all system info
--kernel    get kernel name
--host      get host name # not implement
--version   get kernel version  # not implement   
--arch      get machine type # not implement   

EOF
}
local print_kernel(){
if ([ -f  /usr/bin/uname ] || [ -f /system/bin/uname ]) && \
    ([ -x /usr/bin/uname ] || [ -x /system/bin/uname ]); then
    declare -r platform="$(uname -a)"
    declare -r platform_os="$(expr substr  "${platform}" 1 5)"
    printf "%s" "${platform_os}"
else
    printf "%s" "sorry, unsupport system"
    return 1
fi
}

if [ ! -z "$@" ]; then
    for param in "$@"; do
        shift
        case "$param" in
         "--help")   set -- "$@" "-h"&&help_detect_os;;
         "--kernel") set -- "$@" "-k"&&print_kernel;;
         *)          set -- "$@" "'unknow options'"&&printf  "unrecognized option\n";;
        esac
    done
fi
}
function get_kcptun(){
local detect_downloader(){
    if [ -f /usr/bin/curl ];then
        printf "%s" "curl"
    elif [ -f /usr/bin/wget ];then
        printf "%s" "wget"
    elif [ -f /usr/bin/axel ]; then
        printf "%s" "axel"
    elif [ -f /usr/bin/aria2c ];then
        printf "%s" "aria2c"
    else
        printf "%s" "can not find any downloader,please install wget curl or axel"
        return
    fi
}
local help_extract_package(){
cat <<EOF


--help        display help message
--unpack \$dir      decompress kcptun package to dir

EOF

}
local extract_package(){
    if [ -f "/tmp/kcptun-linux*" ]; then
        rm "/tmp/kcptun-linux*"
    fi
    if [[ "$(detect_os --kernel)" == "Linux" ]] && [ -f /usr/bin/curl ]; then
    declare -r X86_64_URL="https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-linux-amd64-20181114.tar.gz"
    if ( $(detect_downloader) -L "${X86_64_URL}" -o "/tmp/kcptun-linux-amd64-20181114.tar.gz" );then
        printf "%s" "kcptun archive file store at /tmp/kcptun-linux-amd64-20181114.tar.gz\nExtract /tmp/kcptun-linux-amd64-20181114.tar.gz into /tmp\n"
        if (tar -xvf /tmp/kcptun-linux-amd64-20181114.tar.gz -C /tmp);then
            printf "%s" "extract kcptun-linux-amd64-20181114.tar.gz successful\n"
        else
            printf "%s" "extract kcptun-linux-amd64-20181114.tar.gz fail, please try again."
            return
        fi
    else
        printf "%s" "download kcptun package fail, please try again!"
    fi

    elif [[ "$(detect_os --kernel)" == "Drawin" ]] && [ -f /usr/bin/curl ]; then
    declare -r Drawin_URL="https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-darwin-amd64-20181114.tar.gz"
    $(detect_downloader) -L "${Drawin_URL}" -o "/tmp/kcptun-linux-amd64-20181114.tar.gz"
    else
        printf "%s" "Only support Linux which install with curl"
        return
    fi
}
if [ ! -z '$@' ]; then
    for param in "$@"; do
        shift
        case "$param" in
         "--help")    set -- "$@" "-h"&&help_extract_package&&return||return;;
         "--unpack")  set -- "$@" "--unpack $1"&&extract_package&&return||return;;
         *)           set -- "$@" "'unknow options'"&&printf  "unrecognized option\n";;
        esac
    done
fi
}

function http_proxy(){
declare -r DIR="$(cd "$(dirname "$0")" && pwd)"
if [ ! -f "/tmp/client_linux_amd64" ]; then
    printf "%s" "can not find kcptun client, please run \`get_kcptun\` again!"
    return 3;
else
    cp "/tmp/client_linux_amd64" ""${DIR}"/x86_64"
fi

if [ -f $DIR/x86_64/privoxy  ] && [ -f $DIR/x86_64/etc/privoxy/config  ] ; then
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
setup_help
