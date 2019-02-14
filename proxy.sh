#!/bin/bash

# How it is Works??
# shadowsocks client <---> kcptun server <----------> kcptun server <--------------> shadowsocks server

# source ./proxy.sh
# Using this way to lunch all things togeter
# setup_proxy get_kcptun get_shadowsocks  kcptun_client shadowsocks_client privoxy


function ascii_art(){
    cat << EOF
    $$\       $$\                                                                                                 
$$ |      \__|                                                                                                
$$$$$$$\  $$\  $$$$$$\  $$$$$$\$$$$\   $$$$$$\  $$$$$$$\   $$$$$$\  $$\   $$\         $$$$$$$\  $$\  $$\  $$\ 
$$  __$$\ $$ |$$  __$$\ $$  _$$  _$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$ |  $$ |$$$$$$\ $$  __$$\ $$ | $$ | $$ |
$$ |  $$ |$$ |$$ /  $$ |$$ / $$ / $$ |$$ /  $$ |$$ |  $$ |$$$$$$$$ |$$ |  $$ |\______|$$ |  $$ |$$ | $$ | $$ |
$$ |  $$ |$$ |$$ |  $$ |$$ | $$ | $$ |$$ |  $$ |$$ |  $$ |$$   ____|$$ |  $$ |        $$ |  $$ |$$ | $$ | $$ |
$$$$$$$  |$$ |\$$$$$$$ |$$ | $$ | $$ |\$$$$$$  |$$ |  $$ |\$$$$$$$\ \$$$$$$$ |        $$ |  $$ |\$$$$$\$$$$  |
\_______/ \__| \____$$ |\__| \__| \__| \______/ \__|  \__| \_______| \____$$ |        \__|  \__| \_____\____/ 
              $$\   $$ |                                            $$\   $$ |                                
              \$$$$$$  |                                            \$$$$$$  |                                
               \______/                                              \______/                                 

#-> Proxy setup : Auto deploy proxy easily
#-> Author: ZhuZhiHao <zzheasy@gmail.com> <https://github.com/ihexon/proxy-setup>
#->
#-> History:
#->   2-15-2019 : support android(aarch64) and Linux(Linux_x86-64 glibc)


---

Please support me,thanks!

EOF
}

function setup_help(){
cat <<EOF

Run "setup_help" for get help

Invoke "source ./proxy.sh" from your shell to add the following functions to your environment:
- detect_os :   detect your platform
- get_kcptun:   get kcptun binary from github release
- setup_proxy:   deploy socks5 and http proxy
- setup_all:    emmmmmm.....
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
--pmgr      get package manager
--host      get host name # not implement
--version   get kernel version  # not implement yet
--arch      get machine type # not implement yet

EOF
}
print_kernel(){
if ([ -f  /usr/bin/uname ] || [ -f /system/bin/uname ] || [ -f /bin/uname ]); then
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

# detect package manager in OS
__package_mamager_QGnukilUyRnTQvIPGLmbSIYAVZLDI4w9(){
for i in "apt" "yum" "pacman"
    do
        if [ -n "${$(which $i)#*found}" ];then
            echo "$i"
        fi

    done
}
__platform_9WsLZqH4t3ZRcYqEQ2uLZiP610fs2dhf(){
    unset PLT_UNKNOW
    if test "$(detect_os --kernel)" = "Linux" -a "$(detect_os --arch)" = "x86_64"; then
        PLT="$(printf "%s" "Linux-x86_64")"
    elif test $(detect_os --kernel) = "Linux" -a $(detect_os --arch) = "aarch64" -o $(detect_os --arch) = "armv8l" && test -f  "/system/bin/linker"; then
        PLT="$(printf "%s" "Android-x64")"
    elif test $(detect_os --kernel) = "Linux" -a $(detect_os --arch) = "aarch64" -o $(detect_os --arch) = "armv8l"; then
        PLT="$(printf "%s" "Linux-armv8")"
    elif test $(detect_os --kernel) = "Linux" -a $(detect_os --arch) = armv7l; then
        PLT="$(printf "%s" "Linux-armv7l")"
    else
        PLT_UNKNOW="1"
        PLT="$(printf "%s" "Linux-unknow")"
        MSG="$(printf "%s" "Do not support this architecture yet")"
    fi

    if [[ "$PLT_UNKNOW" != "1" ]]; then
        MSG="$(printf "%s" "Staring proxy-setup...")"
        printf "\n\n\nPlatform: \e[32m%s\n%s\n\e[0m\n\n\n" "$PLT" "$MSG"
    else
        MSG="$(printf "%s" "Error, not support this architecture.")"
        printf "\n\n\nPlatform: \e[31m%s\n%s\n\e[0m\n\n\n" "$PLT" "$MSG"

    fi
    unset PLT_UNKNOW

}

if [ ! -z "$@" ]; then
    for param in "$@"; do
        shift
        case "$param" in
         "--help")   set -- "$@" "-h"&&help_detect_os;;
         "--kernel") set -- "$@" "-k"&&print_kernel;;
         "--arch")   set -- "$@" "-arch"&&__print_arch;;
         "--pmgr")   set -- "$@" "-pmgr"&&__package_mamager_QGnukilUyRnTQvIPGLmbSIYAVZLDI4w9;;
         "--plt")    set -- "$@" "plt"&&__platform_9WsLZqH4t3ZRcYqEQ2uLZiP610fs2dhf;;
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
                printf "%s\n" "extract kcptun-linux-arm-20181114.tar.gz successful"
            else
                printf "%s\n" "extract kcptun-linux-arm-20181114.tar.gz fail, please try again."
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
        printf "%s" "Internet install Only support Linux(architecture X86_64,ARM,AARCH) which install with curl"
            return
    fi
else
    # Using local package in prebuild/kcptun-linux-*.tar.xz

    # x86_64 logical
    if [[ "$(detect_os --kernel)" == "Linux" ]] && [[ $(detect_os --arch) == "x86_64" ]]; then
    printf "%s\n%s\n" "X64 Architecture" "Using local package in prebuild/kcptun-linux-amd64-20181114.tar.gz"
        if [ -f prebuild/kcptun-linux-amd64-20181114.tar.gz ];then
            printf "%s\n" "extract kcptun package now...."
            if (tar -xvf prebuild/kcptun-linux-amd64-20181114.tar.gz -C x86_64);then
                printf "%s\n" "extract kcptun package Successful"
            else
                printf "%s\n" "extract package faile,the script must work inside project dir, or mybe you have broken installation"
            fi
        else
            printf "%s" "prebuild/kcptun-linux-amd64-20181114.tar.gz do not exit,please using internet install"
            return
        fi
    fi


    if [[ "$(detect_os --kernel)" == "Linux" ]] && [[ $(detect_os --arch) == "aarch64" ]] || [[ $(detect_os --arch) == "arm*" ]] ; then
        if [ -f prebuild/kcptun-linux-arm-20181114.tar.gz ];then
            printf "%s\n%s\n"  "ARM Architecture" "Using local package in prebuild/kcptun-linux-arm-20181114.tar.gz"
            printf "%s\n" "extract kcptun package now...."
            if (tar -xvf prebuild/kcptun-linux-arm-20181114.tar.gz -C arm);then
                printf "%s\n" "extract kcptun package Successful"
            else
                printf "%s\n" "extract package faile,the script must work inside project dir, mybe you have broken installation"
                return
            fi
        fi


        if [[ -d /data/local/tmp ]];then
            printf "%s\n" "ARM Architecture,platform is Android"
        else
            # do something
            # do nothing ,compiled as static binary
            :
        fi

    else
        print "%s\n%s\n" "unkonw platform" "not support this system yet"
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


function get_shadowsocks(){
    # TODO: get_shadowsocks function
    :
}

function setup_proxy(){

#declare -r DIR="$(cd "$(dirname "$0")" && pwd)"

___setup_proxyhelp_GDiRd1VBggVJhYR7qt9gJlCU0URyy6vO(){

cat <<EOF

--setup-ss :   setup shadowsocks proxy
--setup-kcp:   setup kcptun proxy
--kill-all:    kill ss and kcptun client
Look at the source to view more functions:
Github:https://github.com/ihexon/proxy-setup

EOF
}

___setup_shadowsocks_wgJui9NzMMzLM8pbFMnlIaSSUHbsbLVY(){
bool=false
# X86_64 Setup shadowsocks
if [[ "$(detect_os --kernel)" == "Linux" ]] && [[ "$(detect_os --arch)" == "x86_64" ]];then
    if [ -f x86_64/shadowsocks-libev_glibc_x86-64/bin/ss-local ]; then
            printf "%s\n" "Staring shadowsocks"
            printf "%s\n" "message log to log/ss.log"
        if (LD_LIBRARY_PATH=x86_64/shadowsocks-libev_glibc_x86-64/lib:$LD_LIBRARY_PATH ./x86_64/shadowsocks-libev_glibc_x86-64/bin/ss-local -c ./US2.conf &>log/ss.log &);then
            printf "%s\n" "Start ss successful"
        else
            printf "%s\n" "Start shadowsocks failed"
            printf "%s\n" "message log to log/ss.log"
        fi
    else
        printf "%s" "can not found shadowsocks"
    fi
else
    if [[ "$(detect_os --kernel)" == "Linux" ]] && \
        [[ ("$(detect_os --arch)" == "aarch64") ]] || [[ "$(detect_os --arch)" == "armv8l" ]];then
            if [ -f  /system/bin/linker64 ];then
                printf "%s\n%s\n" "Platform: Android aarch64/armv8" "Start shadowsocks for Android"
                if [ -f ./android/shadowsocks-libev_android/arm64-v8a/libss-local.so ];then
                    chmod +x ./android/shadowsocks-libev_android/arm64-v8a/libss-local.so
                    if ((./android/shadowsocks-libev_android/arm64-v8a/libss-local.so -c ./US2.conf &>log/ss.log )&);then
                        printf "%s\n" "Shadowsocks android start successful"
                    else
                        printf "%s\n" "Shadowsocks for android aarch64/armv8 start failed"
                    fi
                else
                    printf "%s\n" "Shadowsocks for android submodule is missing,check the libss-local.so if it in ./android/shadowsocks-libev_android/arm64-v8a/ dir"
                fi
            elif [ -f /system/bin/linker ];then
                printf "%s\n%s\n" "Platform: Android aarch64/armv8" "Start shadowsocks for Android"
                if [ -f ./android/shadowsocks-libev_android/armeabi-v7a/libss-local.so ];then
                    if (./android/shadowsocks-libev_android/armeabi-v7a/libss-local.so -c ./US2.conf &>log/ss_android_armv7a.log );then
                        printf "%s\n" "Shadowsocks android start successful"
                        printf "%s\n" "message log to log/ss_android_armv7a.log"
                    else
                        printf "%s\n" "Shadowsocks for android armv7a start failed"
                        printf "%s\n" "message log to log/ss_android_armv7a.log"
                    fi
                else
                    printf "%s\n" "Shadowsocks for android submodule is missing,check the libss-local.so if it in ./android/shadowsocks-libev_android/arm64-v8a/ dir"
                fi

            else
                # TODO : ARM GLIBC BOARD support
                # Normal arm board base glibc is not support yet,but soon it come
                :
            fi
        elif [ "$bool" = true ];then
            :
            # CYGWIN
        elif [ "$bool" = true ];then
            :
            # MACOS
        else
            printf "%s\n" "unsupport system"
        fi
fi
}

___setup_kcptun_ZNIXZqrwykvJ3kahmYQMfFRoehKCgM2O(){
if [[ "$(detect_os --kernel)" == "Linux" ]] && [[ "$(detect_os --arch)" == "x86_64" ]];then
    printf "%s\n" "Platform x86_64 Linux"
    if [ ! -f "./x86_64/kcptun-linux-amd64-20181114/client_linux_amd64" ]; then
        printf "%s\n" "can not find kcptun client, please run \`get_kcptun\` again!"
    else
        printf "%s\n" "Start kcptun client"
        printf "%s\n" "message log to log/kcp.log"
        (./x86_64/kcptun-linux-amd64-20181114/client_linux_amd64 -c kcptun.conf &>log/kcp.log &)
    fi
elif [[ "$(detect_os --kernel)" == "Linux" ]] && [[ "$(detect_os --arch)" == "aarch64" ]] || [[ "$(detect_os --arch)" == "armv8l" ]];then
    printf "%s\n" "Platform  Android&&ARM Linux"
    if [ ! -f "./arm/kcptun-linux-arm-20181114/client_linux_arm7" ]; then
        printf "%s\n" "can not find kcptun client, please run \`get_kcptun\` again!"
    else
        printf "%s\n" "Start kcptun client"
        printf "%s\n" "message log to log/kcp.log"
        (./arm/kcptun-linux-arm-20181114/client_linux_arm7 -c kcptun.conf &>log/kcp.log &)
    fi
else
    printf "%s\n" "setup kcptun:unsupport system"
fi


}


___setup_privoxy_4AuVJlCndZMXrtlmyq7EYSCGTcJXWqabproxy(){
    if [[ "$(detect_os --kernel)" == "Linux" ]] && [[ "$(detect_os --arch)" == "x86_64" ]]; then
        rm -rf /tmp/proxy-setup;
        mkdir /tmp/proxy-setup
        cp -rf ./x86_64/privoxy /tmp/proxy-setup
        (LD_LIBRARY_PATH=./x86_64/privoxy/libs ./x86_64/privoxy/sbin/privoxy --no-daemon /tmp/proxy-setup/privoxy/etc/config &> log/privoxy.log &)
    elif [[ "$(detect_os --kernel)" == "Linux" ]] &&  [[ "$(detect_os --arch)" == "aarch64" ]] || [[ "$(detect_os --arch)" == "armv8l" ]]; then
        #printf "%s\n" "Android"
        DIR=$(pwd)
        cp -rf ./arm/privoxy-aarch64 /data/local/tmp/privoxy
        $(cd /data/local/tmp/privoxy/etc && ../lib/libloader.so.1 ../sbin/privoxy --no-daemon ./config &> $DIR/log/privoxy.log) &
        printf "%s" "privoxy start"

    else
        echo privoxy start failed

    fi
}


if [ -z "$@" ];then
    ___setup_proxyhelp_GDiRd1VBggVJhYR7qt9gJlCU0URyy6vO
fi
if [ ! -z "$@" ];then
    for param in "$@"; do
        shift
        case "$param" in
            "--setup-ss") set -- "$@" "-ss"&&___setup_shadowsocks_wgJui9NzMMzLM8pbFMnlIaSSUHbsbLVY;;
            "--setup-kcp")     set -- "$@" "-kcp"&&___setup_kcptun_ZNIXZqrwykvJ3kahmYQMfFRoehKCgM2O;;
            "--setup-privoxy") set -- "$@" "-http"&&___setup_privoxy_4AuVJlCndZMXrtlmyq7EYSCGTcJXWqabproxy;;
            *)          set -- "$@" "'unknow options'"&&printf  "unrecognized option\n";;
        esac
    done

fi


}

function setup_all(){

    kill_all &> /dev/null
    kill_all &> /dev/null
    setup_proxy --setup-kcp
    setup_proxy --setup-ss
    setup_proxy --setup-privoxy
}


function kill_all(){

    if [[ "$(detect_os --kernel)" == "Linux" ]] && [[ "$(detect_os --arch)" == "x86_64" ]]; then
    chmod +x ./x86_64/common_bins/killall
    ./x86_64/common_bins/killall ss-local\
   client_linux_amd64 \
   client_linux_am \
   privoxy
   else
       (killall   libss-local.so \
   client_linux_am \
   ./arm/kcptun-linux-arm-20181114/client_linux_arm7 \
   client_linux_arm7 \
   libloader.so.1 )
   fi
}


setup_help
