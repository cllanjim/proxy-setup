# pre-build shadowsocks-libev

- version : 3.2.0


bundle library:

```
libmbedcrypto.so.0
libmbedcrypto.so.2.4.2
libpcre.so.3
libpcre.so.3.13.3
libshadowsocks-libev.a
libshadowsocks-libev.la
libsodium.so.18
libsodium.so.18.1.1
```

If you prefer to running this module separately, you must explicitly indicate the environment `LD_LIBRARY_PATH` to `lib`.


```shell
export LD_LIBRARY_PATH=./lib
./bin/ss-local -c config.yml

```

This submodule acts as a [socks5 proxy](https://en.wikipedia.org/wiki/Shadowsocks) for the proxy-setup project.
