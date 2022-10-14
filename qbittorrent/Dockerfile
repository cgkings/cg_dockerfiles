#基于哪个镜像制作
FROM debian:testing-slim
#设置环境变量
ENV TZ=Asia/Shanghai \
    PUID="$UID" \
    PGID="$GID" \
    WEBUI_PORT=8070 \
    BT_PORT=34567
#工作目录
WORKDIR /root
#复制安装脚本
COPY ./install.sh /root
#复制启动脚本
COPY ./run.sh /usr/sbin
#执行安装脚本
RUN bash install.sh
#暴露站点文件夹
VOLUME /data
#暴露配置文件
VOLUME /etc/qBittorrent /downloads
#暴露端口
EXPOSE "${WEBUI_PORT}" "${BT_PORT}"
#运行
CMD ["/usr/sbin/run.sh"]