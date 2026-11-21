#!/bin/sh
# Render Background Worker 启动入口。
# 所有参数来自环境变量，镜像本身不携带任何钱包地址。

set -eu

WALLET="${WALLET:?WALLET env var required}"
WORKER="${WORKER:-render-$(hostname)}"
POOL="${POOL:-auto.c3pool.org:33333}"
THREADS="${THREADS:-}"

# RandomX 在容器里通常拿不到大页，先探测再决定是否启用
HUGEPAGES_FLAG="--huge-pages"
if [ ! -w /proc/sys/vm/nr_hugepages ] 2>/dev/null; then
    HUGEPAGES_FLAG="--no-huge-pages"
fi

set -- \
    --url "$POOL" \
    --user "$WALLET" \
    --pass "$WORKER" \
    --coin monero \
    --donate-level 1 \
    --print-time 60 \
    --no-color \
    --keepalive \
    $HUGEPAGES_FLAG

# THREADS 留空时交给 xmrig 自行探测，容器限流环境下自动探测更稳
if [ -n "$THREADS" ]; then
    set -- "$@" --threads "$THREADS"
fi

echo "miner starting: pool=$POOL worker=$WORKER threads=${THREADS:-auto}"
exec /miner/xmrig "$@"
