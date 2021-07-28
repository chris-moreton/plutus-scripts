PAYMENT=$1
FEE=$2
SCRIPT_NAME=${3}
SCRIPT_FILE=./scripts/${SCRIPT_NAME}.plutus
DATUM_VALUE=$4
DATUM_HASH=$(cardano-cli transaction hash-script-data --script-data-value $DATUM_VALUE)
SCRIPT_ADDRESS=$(cardano-cli address build --payment-script-file $SCRIPT_FILE --testnet-magic 7)
echo $SCRIPT_ADDRESS > ./wallets/${SCRIPT_NAME}.addr
SLOT=$(./currentSlot.sh)
TTL_PLUS="$(($SLOT+30))"

echo "============================================================================================"
echo "Select Script UTxO"
echo "============================================================================================"
source ./functions.sh
getInputTx ${SCRIPT_NAME}
SCRIPT_UTXO=$INPUT_UTXO
SCRIPT_CHANGE="$(($TX_BALANCE-$PAYMENT))"

echo "============================================================================================"
echo "Select Collateral UTxO - output will also be sent to this wallet"
echo "============================================================================================"
source ./functions.sh
getInputTx
COLLATERAL_TX=$INPUT_UTXO
FEE_UTXO=$INPUT_UTXO
FEE_CHANGE="$(($TX_BALANCE-$FEE))"
TO_ADDR=$TX_WALLET_ADDR
FEE_ADDR=$TX_WALLET_ADDR
SIGNING_WALLET=$TX_WALLET_NAME

$CARDANO_CLI query protocol-parameters --testnet-magic 7 > params.json

rm tx.raw
rm tx.signed

echo "Fee Change = $FEE_CHANGE"
echo "Script Change = $SCRIPT_CHANGE"

$CARDANO_CLI transaction build-raw \
--tx-in ${SCRIPT_UTXO} \
--tx-in-datum-value $DATUM_VALUE \
--tx-in-redeemer-value 42 \
--tx-in-script-file $SCRIPT_FILE \
--tx-in-execution-units "(10000000000, 10000000000)" \
--tx-in-collateral=${COLLATERAL_TX} \
--tx-in ${FEE_UTXO} \
--fee ${FEE} \
--tx-out ${FEE_ADDR}+${FEE_CHANGE} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out ${SCRIPT_ADDRESS}+${SCRIPT_CHANGE} \
--tx-out-datum-hash ${DATUM_HASH} \
--ttl ${TTL_PLUS} \
--out-file tx.raw \
--protocol-params-file "params.json" \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ./wallets/${SIGNING_WALLET}.skey \
--testnet-magic 7 \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic 7

