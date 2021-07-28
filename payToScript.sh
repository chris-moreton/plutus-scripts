source ./functions.sh
getInputTx

FROM_ADDR=$TX_WALLET_ADDR
SLOT=$(./currentSlot.sh)
PAYMENT=$1
FEE=$2
CHANGE="$(($TX_BALANCE-$PAYMENT-$FEE))"
TTL_PLUS="$(($SLOT+30))"
SCRIPT_ADDRESS=$(cardano-cli address build --payment-script-file ./scripts/${3}.plutus --testnet-magic 7)
DATUM_HASH=$(cardano-cli transaction hash-script-data --script-data-value $4)
TO_ADDR=$SCRIPT_ADDRESS

$CARDANO_CLI transaction build-raw \
--tx-in ${INPUT_UTXO} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out-datum-hash ${DATUM_HASH} \
--tx-out ${FROM_ADDR}+${CHANGE} \
--ttl ${TTL_PLUS} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ~/wallets/${TX_WALLET_NAME}.skey \
--testnet-magic 7 \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic 7

