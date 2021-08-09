source ./functions.sh

PAYMENT=$1
FEE=$2
SCRIPT_NAME=${3}
SCRIPT_FILE=./scripts/${SCRIPT_NAME}.plutus
DATUM_VALUE=$4
if [ -z "$5" ]; then REDEEMER_VALUE=42; else REDEEMER_VALUE=$5; fi

DATUM_HASH=$($CARDANO_CLI transaction hash-script-data --script-data-value "$DATUM_VALUE")
SCRIPT_ADDRESS=$($CARDANO_CLI address build --payment-script-file $SCRIPT_FILE --testnet-magic $TESTNET_MAGIC_NUM)
echo $SCRIPT_ADDRESS > ./wallets/${SCRIPT_NAME}.addr
SLOT=$(./currentSlot.sh)

section "Select Script UTxO"
getInputTx ${SCRIPT_NAME}
SCRIPT_UTXO=$SELECTED_UTXO
SCRIPT_CHANGE="$(($SELECTED_UTXO_LOVELACE-$PAYMENT))"

section "Select Collateral UTxO"
getInputTx
COLLATERAL_TX=$SELECTED_UTXO
FEE_UTXO=$SELECTED_UTXO
FEE_CHANGE="$(($SELECTED_UTXO_LOVELACE-$FEE))"
FEE_ADDR=$SELECTED_WALLET_ADDR
SIGNING_WALLET=$SELECTED_WALLET_NAME

read -p 'Receiving Wallet: ' TO_WALLET_NAME
walletAddress $TO_WALLET_NAME
TO_ADDR=$WALLET_ADDRESS

$CARDANO_CLI query protocol-parameters --testnet-magic $TESTNET_MAGIC_NUM > params.json

removeTxFiles

if (($FEE_CHANGE <= 0)); then
	echo "Fee UTxO too small"
	exit
fi

$CARDANO_CLI transaction build-raw \
--tx-in ${SCRIPT_UTXO} \
--tx-in-datum-value "${DATUM_VALUE}" \
--tx-in-redeemer-value "${REDEEMER_VALUE}" \
--tx-in-script-file $SCRIPT_FILE \
--tx-in-execution-units "(10000000000, 10000000000)" \
--tx-in-collateral=${COLLATERAL_TX} \
--tx-in ${FEE_UTXO} \
--fee ${FEE} \
--tx-out ${FEE_ADDR}+${FEE_CHANGE} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out ${SCRIPT_ADDRESS}+${SCRIPT_CHANGE} \
--tx-out-datum-hash ${DATUM_HASH} \
--out-file tx.raw \
--protocol-params-file "params.json" \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ./wallets/${SIGNING_WALLET}.skey \
--testnet-magic $TESTNET_MAGIC_NUM \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM
