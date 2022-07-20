#基于哪个镜像制作
FROM debian:bookworm-slim
#设置环境变量
ENV TZ=Asia/Shanghai \
    PUID="$UID" \
    PGID="$GID" \
    WEBUI_PORT=8070 \
    BT_PORT=34567 \
    TL=https://githubraw.sleele.workers.dev/XIU2/TrackersListCollection/master/best.txt \
    SHELL=/bin/bash \
    QBITTORRENT_HOME=/etc/qBittorrent
#工作目录
WORKDIR /root
#复制启动脚本
COPY ./run.sh /usr/sbin
#运行
RUN apt install -y curl jq qbittorrent-nox python3 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/qBittorrent \
    && mkdir -p /etc/qBittorrent/data/GeoIP \
    && mkdir -p /downloads \
    && echo "${TZ}" > /etc/timezone \
    && useradd qbittorrent -u ${PUID} -U -m -d /etc/qBittorrent -s /sbin/nologin \
    && chmod +x /usr/sbin/run.sh
#暴露站点文件夹
VOLUME /data
#暴露配置文件
VOLUME /etc/qBittorrent /downloads
#暴露端口
EXPOSE "${WEBUI_PORT}" "${BT_PORT}"
#运行
CMD ["/usr/sbin/run.sh"]