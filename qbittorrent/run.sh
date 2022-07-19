#!/bin/bash
#/etc/qBittorrent/config/qBittorrent.conf


if [ -f "/etc/qBittorrent/config/qBittorrent.conf" ];then
	echo -e "y" | qbittorrent-nox --profile=/etc
else
	curl -kLo /etc/qBittorrent/config.tar.gz https://github.com/cgkings/qbt/raw/main/config.tar.gz
	cd /etc/qBittorrent/ && tar -xvf /etc/qBittorrent/config.tar.gz
	rm -rf /etc/qBittorrent/config.tar.gz
	mkdir -p /etc/qBittorrent/data/GeoIP
	mv -f /root/GeoLite2-Country.mmdb /etc/qBittorrent/data/GeoIP/GeoLite2-Country.mmdb
	curl -kLo /etc/qBittorrent/cg_qbt.sh https://github.com/cgkings/script-store/raw/master/script/cg_qbt.sh
	chmod +x /etc/qBittorrent/cg_qbt.sh
	echo -e "y" | qbittorrent-nox --profile=/etc
	tail -100f /etc/qBittorrent/data/logs/qbittorrent.log
fi
