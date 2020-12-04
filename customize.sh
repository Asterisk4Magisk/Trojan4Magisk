#!/sbin/sh
#####################
# trojan Customization
#####################
SKIPUNZIP=1
ASH_STANDALONE=1

# prepare trojan execute environment
ui_print "- Prepare trojan execute environment."
mkdir -p /data/trojan
mkdir -p /data/trojan/dnscrypt-proxy
mkdir -p /data/trojan/run
mkdir -p $MODPATH/scripts
mkdir -p $MODPATH/system/bin
mkdir -p $MODPATH/system/etc

download_trojan_zip="/data/trojan/run/trojan-go.zip"
custom="$(dirname ${ZIPFILE})/trojan-go.zip"

if [ -f "${custom}" ]; then
  cp "${custom}" "${download_trojan_zip}"
  ui_print "Info: Custom trojan-go found, starting installer"
else
  case "${ARCH}" in
    arm)
      version="trojan-go-linux-armv7.zip"
      ;;
    arm64)
      version="trojan-go-linux-armv8.zip"
      ;;
    x86)
      version="trojan-go-linux-386.zip"
      ;;
    x64)
      version="trojan-go-linux-amd64.zip"
      ;;
  esac
  if [ -f /sdcard/Download/"${version}" ]; then
    cp /sdcard/Download/"${version}" "${download_trojan_zip}"
    ui_print "Info: trojan-go already downloaded, starting installer"
  else
    # download latest trojan-go from official link
    ui_print "- Connect official trojan download link."
    if [ $BOOTMODE ! = true ] ; then
      abort "Error: Please install in Magisk Manager"
    fi
    official_trojan_link="https://github.com.cnpmjs.org/p4gefau1t/trojan-go/releases"
    latest_trojan_version=`curl -k -s https://api.github.com/repos/p4gefau1t/trojan-go/releases | grep -m 1 "tag_name" | grep -o "v[0-9.]*"`
    if [ "${latest_trojan_version}" = "" ] ; then
      ui_print "Error: Connect official trojan download link failed." 
      ui_print "Tips: You can download trojan core manually,"
      ui_print "      and put it in /sdcard/Download"
      abort
    fi
    ui_print "- Download latest trojan core ${latest_trojan_version}-${ARCH}"
    curl "${official_trojan_link}/download/${latest_trojan_version}/${version}" -k -L -o "${download_trojan_zip}" >&2
    if [ "$?" != "0" ] ; then
      ui_print "Error: Download trojan core failed."
      ui_print "Tips: You can download trojan core manually,"
      ui_print "      and put it in /sdcard/Download"
      abort
    fi
  fi
fi

# install trojan execute file
ui_print "- Install trojan core $ARCH execute files"
unzip -j -o "${download_trojan_zip}" "geoip.dat" -d /data/trojan >&2
unzip -j -o "${download_trojan_zip}" "geosite.dat" -d /data/trojan >&2
unzip -j -o "${download_trojan_zip}" "trojan-go" -d $MODPATH/system/bin >&2
unzip -j -o "${ZIPFILE}" "trojan/bin/tun2socks" -d $MODPATH/system/bin >&2
unzip -j -o "${ZIPFILE}" 'trojan/scripts/*' -d $MODPATH/scripts >&2
unzip -j -o "${ZIPFILE}" "trojan/bin/$ARCH/dnscrypt-proxy" -d $MODPATH/system/bin >&2
unzip -j -o "${ZIPFILE}" 'service.sh' -d $MODPATH >&2
unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d $MODPATH >&2
rm "${download_trojan_zip}"
# copy trojan data and config
ui_print "- Copy trojan config and data files"
[ -f /data/trojan/softap.list ] || \
echo "192.168.43.0/24" > /data/trojan/softap.list
[ -f /data/trojan/resolv.conf ] || \
unzip -j -o "${ZIPFILE}" "trojan/etc/resolv.conf" -d /data/trojan >&2
unzip -j -o "${ZIPFILE}" "trojan/etc/config.json.template" -d /data/trojan >&2
unzip -j -o "${ZIPFILE}" "trojan/etc/config.json.example" -d /data/trojan >&2
[ -f /data/trojan/dnscrypt-proxy/dnscrypt-blacklist-domains.txt ] || \
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/dnscrypt-blacklist-domains.txt' -d /data/trojan/dnscrypt-proxy >&2
[ -f /data/trojan/dnscrypt-proxy/dnscrypt-blacklist-ips.txt ] || \
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/dnscrypt-blacklist-ips.txt' -d /data/trojan/dnscrypt-proxy >&2
[ -f /data/trojan/dnscrypt-proxy/dnscrypt-cloaking-rules.txt ] || \
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/dnscrypt-cloaking-rules.txt' -d /data/trojan/dnscrypt-proxy >&2
[ -f /data/trojan/dnscrypt-proxy/dnscrypt-forwarding-rules.txt ] || \
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/dnscrypt-forwarding-rules.txt' -d /data/trojan/dnscrypt-proxy >&2
[ -f /data/trojan/dnscrypt-proxy/dnscrypt-proxy.toml ] || \
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/dnscrypt-proxy.toml' -d /data/trojan/dnscrypt-proxy >&2
[ -f /data/trojan/dnscrypt-proxy/dnscrypt-whitelist.txt ] || \
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/dnscrypt-whitelist.txt' -d /data/trojan/dnscrypt-proxy >&2
[ -f /data/trojan/dnscrypt-proxy/example-dnscrypt-proxy.toml ] || \
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/example-dnscrypt-proxy.toml' -d /data/trojan/dnscrypt-proxy >&2
unzip -j -o "${ZIPFILE}" 'trojan/etc/dnscrypt-proxy/update-rules.sh' -d /data/trojan/dnscrypt-proxy >&2
[ -f /data/trojan/config.json ] || \
cp /data/trojan/config.json.example /data/trojan/config.json.example
ln -s /data/trojan/resolv.conf $MODPATH/system/etc/resolv.conf
# generate module.prop
ui_print "- Generate module.prop"
rm -rf $MODPATH/module.prop
touch $MODPATH/module.prop
echo "id=trojan" > $MODPATH/module.prop
echo "name=trojan4magisk" >> $MODPATH/module.prop
echo -n "version=v1.1.0" >> $MODPATH/module.prop
echo ${latest_trojan_version} >> $MODPATH/module.prop
echo "versionCode=20201204" >> $MODPATH/module.prop
echo "author=CerteKim" >> $MODPATH/module.prop
echo "description=trojan-go with service scripts for Android" >> $MODPATH/module.prop

inet_uid="3003"
net_raw_uid="3004"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm  $MODPATH/service.sh    0  0  0755
set_perm  $MODPATH/uninstall.sh    0  0  0755
set_perm  $MODPATH/scripts/start.sh    0  0  0755
set_perm  $MODPATH/scripts/trojan.inotify    0  0  0755
set_perm  $MODPATH/scripts/trojan.service    0  0  0755
set_perm  $MODPATH/scripts/trojan.tproxy     0  0  0755
set_perm  $MODPATH/scripts/dnscrypt-proxy.service   0  0  0755
set_perm  $MODPATH/system/bin/trojan-go  ${inet_uid}  ${inet_uid}  0755
set_perm  $MODPATH/system/bin/tun2socks  0  0  0755
set_perm  /data/trojan                ${inet_uid}  ${inet_uid}  0755
set_perm  $MODPATH/system/bin/dnscrypt-proxy ${net_raw_uid} ${net_raw_uid} 0755
