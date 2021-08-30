cd wallets
$CARDANO_CLI address key-gen --verification-key-file $1.vkey --signing-key-file $1.skey
$CARDANO_CLI address build --payment-verification-key-file $1.vkey --out-file $1.addr --testnet-magic $TESTNET_MAGIC_NUM

