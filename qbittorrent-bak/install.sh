#!/bin/bash
#####	Debian安装qbittorrent

apt-get update
apt install -y qbittorrent-nox curl
rm -rf /var/lib/apt/lists/*
#创建存储配置目录
mkdir -p /etc/qBittorrent
#创建GeoIP数据库路径
mkdir -p /etc/qBittorrent/data/GeoIP
#创建下载目录
mkdir -p /downloads
#下载GeoIP数据库
curl -kLo /root/GeoLite2-Country.mmdb https://github.com/PrxyHunter/GeoLite2/releases/latest/download/GeoLite2-Country.mmdb
chmod +x /usr/sbin/run.sh