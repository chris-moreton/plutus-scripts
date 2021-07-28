CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli
$CLI query tip --testnet-magic 7 | jq -r '.slot'

