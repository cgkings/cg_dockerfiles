# qBittorrent
qBittorrent是一个跨平台的自由BitTorrent客户端，其图形用户界面是由Qt所写成的。使用libtorrent作为后端。该项目可轻松帮助您构建qBittorrent Docker版，或在Docker中直接运行qBittorrent

## 版本说明

* 基于debian:bookworm-slim镜像制作
* qBittorrent版本为`v4.4.3.1`

## 自行构建

```bash
#克隆此项目
git clone https://github.com/cgkings/qbt.git
#进入项目
cd qbittorrent
#构建docker镜像
docker build -t qbittorrent:latest .
```



## 运行

不想自行构建的，可通过已构建好的镜像直接运行：

```bash
docker run -d \
  --name=qbittorrent \
  -p 51414:51414 \
  -p 51414:51414/udp \
  -p 8077:8077 \
  -v /home/qbt/config:/etc/qBittorrent \
  -v /home/qbt/downloads:/downloads \
  -v /usr/bin/fclone:/usr/bin/fclone \
  -v /root/.config/rclone/rclone.conf:/root/.config/rclone/rclone.conf \
  -v /home/vps_sa/ajkins_sa:/home/vps_sa/ajkins_sa \
  --restart unless-stopped \
  cgkings/qbittorrent:latest
```

* `7881`：用于传入连接的端口，TCP/UDP都需要映射，且主机端口和容器端口必须一致，否则无法下载和上传
* `18080`：qBittorrentWEBUI访问端口，主机端口和容器端口必须一致，否则无法打开WEB界面
* `/home/qbt/config`：qbittorrent配置文件存储目录，可自行修改
* `/home/qbt/downloads`：下载目录，可自行修改
* `/usr/bin/fclone`：fclone或rclone二进制文件所在目录，可通过`command -v fclone`获取
* `/root/.config/rclone/rclone.conf`：rclone配置目录，你没有改过配置路径，一般也不用改
* `/home/vps_sa/ajkins_sa`：fclone配置里的SA所在目录

## 使用说明

运行成功后可通过`http://IP:18080`进行访问，

* 初始用户名：`admin`
* 密码：`adminadmin`

登录后请务必修改。



## 容器内目录说明

* 容器内配置文件位于`/etc/qBittorrent`
* 下载目录位于`/downloads`



## 联系我

* E-mail：cgkigns@gmail.com
