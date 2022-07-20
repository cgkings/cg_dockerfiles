#!/bin/bash
#/etc/qBittorrent/config/qBittorrent.conf
update_tracker() {
  wget -O /tmp/trackers_list.txt "$TL"
  Newtrackers="Bittorrent\TrackersList=$(awk '{if(!NF){next}}1' /tmp/trackers_list.txt | sed ':a;N;s/\n/\\n/g;ta')"
  Oldtrackers="$(grep TrackersList= /etc/qBittorrent/config/qBittorrent.conf)"
  echo "$Newtrackers" >/tmp/Newtrackers.txt
  if [ -e "/tmp/trackers_list.txt" ]; then
    if [ "$Newtrackers" == "$Oldtrackers" ]; then
      echo trackers文件一样,不需要更新。
    else
      sed -i '/Bittorrent\\TrackersList=/r /tmp/Newtrackers.txt' /etc/qBittorrent/config/qBittorrent.conf
      sed -i '1,/^Bittorrent\\TrackersList=.*/{//d;}' /etc/qBittorrent/config/qBittorrent.conf
      echo 已更新trackers。
    fi
    rm /tmp/trackers_list.txt
    rm /tmp/Newtrackers.txt
  else
    echo 更新文件未正确下载，更新未成功，请检查网络。
  fi
}

if [ -f "/etc/qBittorrent/config/qBittorrent.conf" ]; then
  update_tracker
  echo -e "y" | qbittorrent-nox -d --webui-port="$WEBUI_PORT" --profile=/etc/qBittorrent/config
else
  curl -kLo /etc/qBittorrent/config.tar.gz https://github.com/cgkings/cg_dockerfiles/raw/main/qbittorrent/config.tar.gz
  cd /etc/qBittorrent/ && tar -xvf /etc/qBittorrent/config.tar.gz
  rm -rf /etc/qBittorrent/config.tar.gz
  curl -kLo /etc/qBittorrent/cg_qbt.sh https://github.com/cgkings/script-store/raw/master/script/cg_qbt.sh
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
  update_tracker
  echo -e "y" | qbittorrent-nox -d --webui-port="$WEBUI_PORT" --profile=/etc/qBittorrent/config
  tail -100f /etc/qBittorrent/data/logs/qbittorrent.log
fi
