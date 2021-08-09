source ./functions.sh
getInputTx $5

FROM_ADDR=$SELECTED_WALLET_ADDR
PAYMENT=$1
FEE=$2
CHANGE="$(($SELECTED_UTXO_LOVELACE-$PAYMENT-$FEE))"
SCRIPT_ADDRESS=$($CARDANO_CLI address build --payment-script-file ./scripts/${3}.plutus --testnet-magic $TESTNET_MAGIC_NUM)
DATUM_HASH=$($CARDANO_CLI transaction hash-script-data --script-data-value "$4")
TO_ADDR=$SCRIPT_ADDRESS

$CARDANO_CLI transaction build-raw \
--tx-in ${SELECTED_UTXO} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out-datum-hash ${DATUM_HASH} \
--tx-out ${FROM_ADDR}+${CHANGE} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ./wallets/${SELECTED_WALLET_NAME}.skey \
--testnet-magic $TESTNET_MAGIC_NUM \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM

