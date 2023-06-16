#!/bin/bash
echo "${TZ}" > /etc/timezone
apt update && apt install -y curl python3 software-properties-common && add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y && apt install -y qbittorrent-nox && rm -rf /var/lib/apt/lists/*
#创建路径
mkdir -p /etc/qBittorrent/data/GeoIP
#创建下载目录
mkdir -p /downloads
#下载GeoIP数据库
curl -kLo /root/GeoLite2-Country.mmdb https://github.com/helloxz/qbittorrent/raw/main/GeoLite2-Country.mmdb
chmod +x /usr/sbin/run.sh
