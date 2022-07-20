#!/bin/bash
#/etc/qBittorrent/config/qBittorrent.conf

if [ -f "/etc/qBittorrent/config/qBittorrent.conf" ]; then
  echo -e "y" | qbittorrent-nox --profile=/etc
else
  cat > /data/config/qBittorrent.conf << EOF
[General]
ported_to_new_savepath_system=true

[AutoRun]
enabled=true
program=cg_qbt.sh \"%N\" \"%F\" \"%C\" \"%Z\" \"%I\" \"%L\"

[BitTorrent]
Session\AddExtensionToIncompleteFiles=true
Session\AlternativeGlobalDLSpeedLimit=50000
Session\AlternativeGlobalUPSpeedLimit=0
Session\DisableAutoTMMByDefault=false
Session\DisableAutoTMMTriggers\CategorySavePathChanged=false
Session\MaxConnections=-1
Session\MaxConnectionsPerTorrent=-1
Session\MaxUploads=-1
Session\MaxUploadsPerTorrent=-1

[Core]
AutoDeleteAddedTorrentFile=IfAdded

[LegalNotice]
Accepted=true

[Preferences]
Connection\Interface=
Connection\PortRangeMin=${BT_PORT}
Connection\UseUPnP=false
Downloads\SavePath=/data/downloads/
General\Locale=zh
General\UseRandomPort=false
Queueing\QueueingEnabled=true
Queueing\MaxActiveDownloads=5
Queueing\MaxActiveTorrents=-1
Queueing\MaxActiveUploads=-1
WebUI\Address=*
WebUI\AlternativeUIEnabled=false
WebUI\CSRFProtection=false
WebUI\Enabled=true
WebUI\LocalHostAuth=false
WebUI\Port=${WEBUI_PORT}
EOF
  curl -kLo /etc/qBittorrent/config.tar.gz https://github.com/helloxz/qbittorrent/raw/main/config.tar.gz
  cd /etc/qBittorrent/ && tar -xvf /etc/qBittorrent/config.tar.gz
  rm -rf /etc/qBittorrent/config.tar.gz
  mkdir -p /etc/qBittorrent/data/GeoIP
  mv /root/GeoLite2-Country.mmdb /etc/qBittorrent/data/GeoIP/GeoLite2-Country.mmdb
  echo -e "y" | qbittorrent-nox --profile=/etc
  tail -100f /etc/qBittorrent/data/logs/qbittorrent.log
fi
