ADDRESS=$(cat ./wallets/main.addr)
KEY=$1
curl -v -XPOST "https://faucet.alonzo-purple.dev.cardano.org/send-money/$ADDRESS?apiKey=$KEY"

