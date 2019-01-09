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
- setup_proxy:   deploy socks5 and http proxy
- setup_help:   display help
Environment options:
Look at the source to view more functions:
Github:https://github.com/ihexon/proxy-setup


EOF
}

function detect_os(){
help_detect_os(){
printf "%s" "detect_os -- display system info"
cat <<EOF

--help      get help
--all       get all system info # not implement yet
--kernel    get kernel name
--host      get host name # not implement
--version   get kernel version  # not implement yet
--arch      get machine type # not implement yet

EOF
}
print_kernel(){
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

# Print architecture
__print_arch(){
    declare -r platform_arch=$(uname -m)
    printf "%s" "${platform_arch}"
}

if [ ! -z "$@" ]; then
    for param in "$@"; do
        shift
        case "$param" in
         "--help")   set -- "$@" "-h"&&help_detect_os;;
         "--kernel") set -- "$@" "-k"&&print_kernel;;
         "--arch")   set -- "$@" "-arch"&&__print_arch;;
         *)          set -- "$@" "'unknow options'"&&printf  "unrecognized option\n";;
        esac
    done
fi
}
function get_kcptun(){
detect_downloader(){
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
help_extract_package(){
cat <<EOF

--help        display help message
--unpack \$dir      decompress kcptun package to dir

EOF

}
extract_package(){
if [ -f "/tmp/kcptun-linux*" ]; then
        rm "/tmp/kcptun-linux*"
fi
declare -i using_local_kcp=1 # if using internet to download package or using local package
if [ "${using_local_kcp}" -eq 0 ];then
    # x86_64 architecture logic 
    if [[ "$(detect_os --kernel)" == "Linux" ]] && [[ "$(detect_os --arch)" == "x86_64" ]]; then
        declare -r download_url="https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-linux-amd64-20181114.tar.gz"
        if ( $(detect_downloader) -L "${download_url}" -o "/tmp/kcptun-linux-amd64-20181114.tar.gz" );then
             printf "%s\n%s\n"   "kcptun archive file store at /tmp/kcptun-linux-amd64-20181114.tar.gz" \ 
                            "Extract /tmp/kcptun-linux-amd64-20181114.tar.gz into /tmp"
            if (tar -xvf /tmp/kcptun-linux-amd64-20181114.tar.gz -C /tmp);then
                printf "%s\n" "extract kcptun-linux-amd64-20181114.tar.gz successful"
            else
                printf "%s\n" "extract kcptun-linux-amd64-20181114.tar.gz fail, please try again."
                return
            fi
        else
            printf "%s" "download kcptun package fail, please try again!"
            return
        fi
    # The logic ARM architecture
    elif [[ "$(detect_os --kernel)" == ""Linux ]] && [[ "$(detect_os --arch)" == "armv8l" ]]; then
        declare -r download_url="https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-linux-arm-20181114.tar.gz"
        if  ($(detect_downloader) -L "${download_url}" -o "/tmp/kcptun-linux-arm-20181114.tar.gz");then
             printf "%s\n%s\n"   "kcptun archive file store at /tmp/kcptun-linux-arm-20181114.tar.gz" \ 
                            "Extract /tmp/kcptun-linux-arm-20181114.tar.gz into /tmp"
            if (tar -xvf /tmp/kcptun-linux-arm-20181114.tar.gz -C /tmp);then
                printf "%s\n" "extract kcptun-linux-amd64-20181114.tar.gz successful"
            else
                printf "%s\n" "extract kcptun-linux-amd64-20181114.tar.gz fail, please try again."
                return
            fi
        else
            printf "%s" "download kcptun package fail, please try again!"
            return
        fi

    
    # I dont have MacOs.If I have chance test on MacOS,I will finish this pices of code
    ####################################################################################
    elif [[ "$(detect_os --kernel)" == "Drawin" ]]; then
        declare -r download_url="https://github.com/xtaci/kcptun/releases/download/v20181114/kcptun-darwin-amd64-20181114.tar.gz"
        $(detect_downloader) -L "${download_url}" -o "/tmp/kcptun-linux-amd64-20181114.tar.gz"
    ####################################################################################
    else
        printf "%s" "Only support Linux(architecture X86_64,ARM,AARCH) which install with curl"
            return
    fi
else
    # Using local package in prebuild/kcptun-linux-*.tar.xz
    if [ "$(detect_os --kernel)" == "Linux" ]; then
    printf "%s" "Using local package in prebuild/kcptun-linux-amd64-20181114.tar.gz"
    fi
fi
}
if [ ! -z '$@' ]; then
    for param in "$@"; do
        shift
        case "$param" in
         "--help")    set -- "$@" "-h"&&help_extract_package&&return||return;;
         "--unpack")  set -- "$@" "--unpack $1"&&extract_package&&return||return;;
         *)           set -- "$@" "'unknow options'"&&printf  "unrecognized option\n"&&return||return;;
        esac
    done
fi
}

function setup_proxy(){
declare -r DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$(detect_os --kernel)" == "Linux" ] && [ "$(detect_os --arch)" == "x86_64" ] && [ ! -f "$DIR/x86_64/client_linux_amd64" ];then
    if [ ! -f "/tmp/client_linux_amd64" ]; then
        printf "%s" "can not find kcptun client, please run \`get_kcptun\` again!"
        return 3;
    else
        cp "/tmp/client_linux_amd64" ""${DIR}"/x86_64"
    fi
else
    printf "%s\n" "find client_linux_amd64"
fi



if ( "$DIR/x86_64/client_linux_amd64" -c "$DIR/configs/kcp.conf" );then
    echo Successful start kcp client
else
    echo "Start kcp client fail,Please try again"
fi




if [ -f $DIR/x86_64/privoxy  ] && [ -f $DIR/x86_64/etc/privoxy/config  ] ; then
    printf "exec %s" "$DIR/bin/privoxy -c $DIR/etc/privoxy/config"
else
    printf "%s" "Can not found privoxy server and its configure files,Maybe you have broken installation"
fi

}
setup_help
