# Trojan-go Magisk Module
A fork of [Xray4Magisk](https://github.com/CerteKim/Xray4Magisk)
This is a Trojan-go module for Magisk, and includes binaries for arm, arm64, x86, x64.

## Included

* [Trojan-go](<https://github.com/p4gefau1t/trojan-go>)
* [dnscrypt-proxy](<https://github.com/DNSCrypt/dnscrypt-proxy>)
* [magisk-module-installer](https://github.com/topjohnwu/magisk-module-installer)
* [go-tun2socks](<https://github.com/eycorsican/go-tun2socks>)

## Install

You can download the release installer zip file and install it via the Magisk Manager App.

### Manual download Trojan-go
Download the correct CPU Architecture Trojan-go zip file and put it in the same folder where you place Xray4Magisk.zip.

such as "trojan-go-linux-armv8.zip"


### Custom Trojan-go
Put any trojan-go.zip in the same folder where you place Xray4Magisk.zip.


## Config

- Trojan config file is store in `/data/trojan/config.json` .

- dnscrypt-proxy config file is store in `/data/trojan/dnscrypt-proxy/` folder, you can update cn domains list via running the shell script `update-rules.sh` or if you dislike the default rules, you can edit them by yourself. ( If you want to disable dnscrypt-proxy, just delete the config file `/data/trojan/dnscrypt-proxy/dnscrypt-proxy.toml` )

- Tips: Please notice that the default configuration has already set inbounds section to cooperate work with transparent proxy script. It is recommended that you only edit the first element of outbounds section to your proxy server and edit file `/data/trojan/appid.list` to select which App to proxy.

## Usage

### Normal usage ( Default and Recommended )

#### Manage service start / stop

- trojan service is auto-run after system boot up by default.
- You can start or stop trojan service by simply turn on or turn off the module via Magisk Manager App. Start service may wait about 10 second and stop service may take effect immediately.



#### Select which App to proxy

- If you expect transparent proxy ( read Transparent proxy section for more detail ) for specific Apps, just write down these Apps' uid in file `/data/trojan/appid.list` . 

  Each App's uid should separate by space or just one App's uid per line. ( for Android App's uid , you can search App's package name in file `/data/system/packages.list` , or you can look into some App like Shadowsocks. )

- If you expect all Apps proxy by trojan with transparent proxy, just write a `ALL` in file `/data/trojan/appid.list` .

- If you expect all Apps proxy by trojan with transparent proxy EXCEPT specific Apps, write down `#bypass` at the first line then these Apps' uid separated as above in file `/data/trojan/appid.list`. 

- Transparent proxy won't take effect until the trojan service start normally and file `/data/trojan/appid.list` is not empty.




### Advanced usage ( for Debug and Develop only )

#### Enter manual mode

If you want to control trojan by running command totally, just add a file `/data/trojan/manual`.  In this situation, trojan service won't start on boot automatically and you cann't manage service start/stop via Magisk Manager App. 



#### Manage service start / stop

- trojan service script is `$MODDIR/scripts/trojan.service`.

- For example, in my environment ( Magisk version: 18100 ; Magisk Manager version v7.1.1 )

  - Start service : 

    `/sbin/.magisk/img/trojan/scripts/trojan.service start`

  - Stop service :

    `/sbin/.magisk/img/trojan/scripts/trojan.service stop`



#### Manage transparent proxy enable / disable

- Transparent proxy script is `$MODDIR/scripts/trojan.tproxy`.

- For example, in my environment ( Magisk version: 18100 ; Magisk Manager version v7.1.1 )

  - Enable Transparent proxy : 

    `/sbin/.magisk/img/trojan/scripts/trojan.tproxy enable`

  - Disable Transparent proxy :

    `/sbin/.magisk/img/trojan/scripts/trojan.tproxy disable`



## Transparent proxy

### What is "Transparent proxy"

> "A 'transparent proxy' is a proxy that does not modify the request or response beyond what is required for proxy authentication and identification". "A 'non-transparent proxy' is a proxy that modifies the request or response in order to provide some added service to the user agent, such as group annotation services, media type transformation, protocol reduction, or anonymity filtering".
>
> ​                                -- [Transparent proxy explanation in Wikipedia](https://en.wikipedia.org/wiki/Proxy_server#Transparent_proxy)

## Uninstall

1. Uninstall the module via Magisk Manager App.
2. You can clean trojan data dir by running command `rm -rf /data/trojan` .


## Trojan-go

Trojan-go is A Trojan proxy written in Go. An unidentifiable mechanism that helps you bypass GFW. It secures your network connections and thus protects your privacy. See [trojan-go](https://github.com/p4gefau1t/trojan-go) for more information.

## Notes

Theoretically, it is possible to support trojan-gfw and trojan-plus.