# proxy-setup 
Auto deploy a proxy(HTTP and Socks5) proxy



# Deploy
Install privoxy.
`apt install privoxy`
Download kcptun client and shadowsocks
```
cp privoxy_config  /etc/privoxy/config
sudo systemctl start privoxy.service
ss-local ./ss.conf &
./client_linux_amd64 -c kcp.conf &
```
available proxy location at:
```
socks5://127.0.0.1:1080
http://127.0.0.1:2018
```
