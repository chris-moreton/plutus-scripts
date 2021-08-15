# generate stake address
$CARDANO_CLI stake-address key-gen --verification-key-file stake.vkey --signing-key-file stake.skey
# extract readable address
$CARDANO_CLI stake-address build --stake-verification-key-file stake.vkey --out-file stake.addr --testnet-magic $TESTNET_MAGIC_NUM

