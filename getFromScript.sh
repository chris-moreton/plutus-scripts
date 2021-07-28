PAYMENT=$1
FEE=$2
SCRIPT_NAME=${3}
SCRIPT_FILE=./scripts/${SCRIPT_NAME}.plutus
DATUM_VALUE=$4
DATUM_HASH=$(cardano-cli transaction hash-script-data --script-data-value $DATUM_VALUE)
SCRIPT_ADDRESS=$(cardano-cli address build --payment-script-file $SCRIPT_FILE --testnet-magic 7)
echo $SCRIPT_ADDRESS > ./wallets/${SCRIPT_NAME}.addr
SLOT=$(./currentSlot.sh)
CHANGE="$(($BALANCE-$PAYMENT-$FEE))"
TTL_PLUS="$(($SLOT+30))"

echo "============================================================================================"
echo "Select Script UTxO"
echo "============================================================================================"
source ./functions.sh
getInputTx ${SCRIPT_NAME}
SCRIPT_UTXO=$INPUT_UTXO

echo "============================================================================================"
echo "Select Collateral UTxO"
echo "============================================================================================"
source ./functions.sh
getInputTx
COLLATERAL_TX=$INPUT_UTXO
TO_ADDR=$TX_WALLET_ADDR

$CARDANO_CLI query protocol-parameters --testnet-magic 7 > params.json

rm tx.raw
rm tx.signed

$CARDANO_CLI transaction build-raw \
--tx-in ${SCRIPT_UTXO} \
--tx-in-datum-value $DATUM_VALUE \
--tx-in-redeemer-value 42 \
--tx-in-script-file $SCRIPT_FILE \
--tx-in-execution-units "(10000000000, 10000000000)" \
--tx-in-collateral=${COLLATERAL_TX} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--protocol-params-file "params.json" \
--tx-out ${SCRIPT_ADDR}+${CHANGE} \
--ttl ${TTL_PLUS} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ~/wallets/${10}.skey \
--testnet-magic 7 \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic 7

