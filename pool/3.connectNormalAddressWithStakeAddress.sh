# create combined address
$CARDANO_CLI address build --payment-verification-key-file payment.vkey --stake-verification-key-file stake.vkey --out-file paymentwithstake.addr --testnet-magic $TESTNET_MAGIC_NUM 
# check balance of address
$CARDANO_CLI query utxo --address $(cat paymentwithstake.addr) --testnet-magic $TESTNET_MAGIC_NUM
