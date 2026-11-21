FROM debian:bookworm-slim

# 只装拉取与解包所需的最小依赖，镜像层越少启动越快
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        tar \
        procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /miner

# 只用官方 xmrig release 的静态构建；第三方"优化版"常被植入他人钱包
RUN curl -fsSL -o xmrig.tar.gz \
        https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz \
    && tar -xzf xmrig.tar.gz --strip-components=1 \
    && rm xmrig.tar.gz \
    && chmod +x /miner/xmrig

COPY start.sh /miner/start.sh
RUN chmod +x /miner/start.sh

# 非 root 运行：容器内挖矿不需要任何特权
RUN useradd --system --create-home --shell /usr/sbin/nologin miner \
    && chown -R miner:miner /miner
USER miner

CMD ["/miner/start.sh"]
