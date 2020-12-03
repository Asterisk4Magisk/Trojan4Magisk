#!/system/bin/sh

MODDIR=${0%/*}

start_proxy () {
  ${MODDIR}/trojan.service start &> /data/trojan/run/service.log && \
  if [ -f /data/trojan/appid.list ] || [ -f /data/trojan/softap.list ] ; then
    ${MODDIR}/trojan.tproxy enable &>> /data/trojan/run/service.log && \
    if [ -f /data/trojan/dnscrypt-proxy/dnscrypt-proxy.toml ] ; then
      ${MODDIR}/dnscrypt-proxy.service enable &>> /data/trojan/run/service.log &
    fi
  fi
}
if [ ! -f /data/trojan/manual ] ; then
  start_proxy
  inotifyd ${MODDIR}/trojan.inotify ${MODDIR}/.. &>> /data/trojan/run/service.log &
fi
