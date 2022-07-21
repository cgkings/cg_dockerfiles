#!/bin/bash
#/etc/qBittorrent/config/qBittorrent.conf
if [ -f "/etc/qBittorrent/config/qBittorrent.conf" ]; then
  echo -e "y" | qbittorrent-nox -d --webui-port="$WEBUI_PORT" --profile=/etc/qBittorrent/config
else
  curl -kLo /etc/qBittorrent/config.tar.gz https://github.com/cgkings/cg_dockerfiles/raw/main/qbittorrent/config.tar.gz
  cd /etc/qBittorrent/ && tar -xvf /etc/qBittorrent/config.tar.gz
  rm -rf /etc/qBittorrent/config.tar.gz
  curl -kLo /etc/qBittorrent/cg_qbt.sh https://github.com/cgkings/script-store/raw/master/script/cg_qbt.sh
  chmod +x /etc/qBittorrent/cg_qbt.sh
  mkdir -p /etc/qBittorrent/data/GeoIP
  mv -f /root/GeoLite2-Country.mmdb /etc/qBittorrent/data/GeoIP/GeoLite2-Country.mmdb
  cat > /etc/qBittorrent/config/qBittorrent.conf << EOF
[General]
ported_to_new_savepath_system=true

[AutoRun]
enabled=true
program=/etc/qBittorrent/cg_qbt.sh \"%N\" \"%F\" \"%C\" \"%Z\" \"%I\" \"%L\"

[BitTorrent]
Session\AddExtensionToIncompleteFiles=true
Session\AddTrackersEnabled=true
Session\AdditionalTrackers=$(curl -s https://githubraw.sleele.workers.dev/XIU2/TrackersListCollection/master/best.txt | awk '{if(!NF){next}}1' | sed ':a;N;s/\n/\\n/g;ta')
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
Downloads\SavePath=/downloads/
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
  echo -e "y" | qbittorrent-nox -d --webui-port="$WEBUI_PORT" --profile=/etc/qBittorrent/config
fi