# generate address keys
$CARDANO_CLI address key-gen --verification-key-file payment.vkey --signing-key-file payment.skey
# extract readable address
$CARDANO_CLI address build --payment-verification-key-file payment.vkey --out-file payment.addr --testnet-magic $TESTNET_MAGIC_NUM
# check balance of address
$CARDANO_CLI query utxo --address $(cat payment.addr) --testnet-magic $TESTNET_MAGIC_NUM
