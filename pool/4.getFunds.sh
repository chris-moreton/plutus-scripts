# request funds
curl -k -v -XPOST "https://faucet.alonzo-purple.dev.cardano.org/send-money/$(cat paymentwithstake.addr)?apiKey=$APIKEY"
# check funds are received (may take several minutes)
$CARDANO_CLI query utxo --address $(cat paymentwithstake.addr) --testnet-magic $TESTNET_MAGIC_NUM


