#!/bin/bash
#/etc/qBittorrent/config/qBittorrent.conf
update_tracker(){
  wget -O /tmp/trackers_list.txt "$TL"
  Newtrackers="Bittorrent\TrackersList=$(awk '{if(!NF){next}}1' /tmp/trackers_list.txt | sed ':a;N;s/\n/\\n/g;ta')"
  Oldtrackers="$(grep TrackersList= /config/qBittorrent/config/qBittorrent.conf)"
  echo "$Newtrackers" >/tmp/Newtrackers.txt
  if [ -e "/tmp/trackers_list.txt" ]; then
    if [ "$Newtrackers" == "$Oldtrackers" ]; then
      echo trackers文件一样,不需要更新。
    else
      sed -i '/Bittorrent\\TrackersList=/r /tmp/Newtrackers.txt' /config/qBittorrent/config/qBittorrent.conf
      sed -i '1,/^Bittorrent\\TrackersList=.*/{//d;}' /config/qBittorrent/config/qBittorrent.conf
      echo 已更新trackers。
    fi
    rm /tmp/trackers_list.txt
    rm /tmp/Newtrackers.txt
    curl -kLo /root/GeoLite2-Country.mmdb https://github.com/PrxyHunter/GeoLite2/releases/latest/download/GeoLite2-Country.mmdb
    mkdir -p /etc/qBittorrent/data/GeoIP
    mv -f /root/GeoLite2-Country.mmdb /etc/qBittorrent/data/GeoIP/GeoLite2-Country.mmdb
  else
    echo 更新文件未正确下载，更新未成功，请检查网络。
  fi
}

if [ -f "/etc/qBittorrent/config/qBittorrent.conf" ]; then
  update_tracker
  echo -e "y" | qbittorrent-nox --webui-port="$WEBUI_PORT" --profile=/etc
else
  curl -kLo /etc/qBittorrent/config.tar.gz https://github.com/helloxz/qbittorrent/raw/main/config.tar.gz
  cd /etc/qBittorrent/ && tar -xvf /etc/qBittorrent/config.tar.gz
  rm -rf /etc/qBittorrent/config.tar.gz
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
Bittorrent\TrackersList=
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
  update_tracker
  echo -e "y" | qbittorrent-nox --webui-port="$WEBUI_PORT" --profile=/etc
  tail -100f /etc/qBittorrent/data/logs/qbittorrent.log
fi
