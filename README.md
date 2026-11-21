# render-miner

Minimal Background Worker image for C3Pool.

## Environment variables

| Name | Required | Default | Meaning |
|---|---|---|---|
| `WALLET` | yes | — | payout address (XMR or USDT) |
| `WORKER` | no | `render-<hostname>` | rig label shown on the dashboard |
| `POOL` | no | `auto.c3pool.org:33333` | stratum endpoint, 33333 is TLS |
| `THREADS` | no | auto | pin RandomX thread count |

## Deploy

Background Worker, Runtime = Docker, source = this repo.
