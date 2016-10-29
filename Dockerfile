FROM cbwang/ssr-docker

ENV KCP_VER 20161028

RUN \
    apk add --no-cache --virtual .build-deps curl \
    && mkdir -p /opt/kcptun \
    && cd /opt/kcptun \
    && curl -fSL https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz | tar xz \
    && rm client_linux_amd64 \
    && cd ~ \
    && apk del .build-deps \
    && apk add --no-cache supervisor
    
COPY supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh
    
ENV KCPTUN_ARGS="-l :29900 -t 127.0.0.1:8989 -crypt salsa20 --mtu 1400 --sndwnd 2048 --rcvwnd 2048 --mode fast2"
EXPOSE 8989/tcp 8989/udp 29900/udp
ENTRYPOINT ["/start.sh"]
