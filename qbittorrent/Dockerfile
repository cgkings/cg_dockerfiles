#基于哪个镜像制作
FROM debian:bookworm-slim
#设置环境变量
ENV TZ=Asia/Shanghai \
    PUID="$UID" \
    PGID="$GID" \
    WEBUI_PORT=8070 \
    BT_PORT=34567 \
    LANG=zh_CN.UTF-8 \
    TL=https://githubraw.sleele.workers.dev/XIU2/TrackersListCollection/master/best.txt \
    SHELL=/bin/bash \
    QBITTORRENT_HOME=/etc/qBittorrent
#工作目录
WORKDIR /root
#复制启动脚本
COPY ./run.sh /usr/sbin
#运行
RUN apk add --no-cache \
    curl \
    openssl \
    qt5-qtbase \
    shadow \
    tzdata \
    jq \
    bash \
    qbittorrent-nox \
    python3 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${QBITTORRENT_HOME} \
    && mkdir -p ${QBITTORRENT_HOME}/data/GeoIP \
    && mkdir -p /downloads \
    && echo "${TZ}" > /etc/timezone \
    && useradd qbittorrent -u ${PUID} -U -m -d ${QBITTORRENT_HOME} -s /sbin/nologin \
    && chmod +x /usr/sbin/run.sh
#暴露站点文件夹
VOLUME /data
#暴露配置文件
VOLUME ${QBITTORRENT_HOME} /downloads
#暴露端口
EXPOSE "${WEBUI_PORT}" "${BT_PORT}"
#运行
CMD ["/usr/sbin/run.sh"]