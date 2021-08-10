source ./functions.sh

PAYMENT=$1
SCRIPT_NAME=${2}
SCRIPT_FILE=./scripts/${SCRIPT_NAME}.plutus
DATUM_VALUE=$3
if [ -z "$4" ]; then REDEEMER_VALUE=42; else REDEEMER_VALUE=$5; fi

DATUM_HASH=$($CARDANO_CLI transaction hash-script-data --script-data-value "$DATUM_VALUE")
SCRIPT_ADDRESS=$($CARDANO_CLI address build --payment-script-file $SCRIPT_FILE --testnet-magic $TESTNET_MAGIC_NUM)
echo $SCRIPT_ADDRESS > ./wallets/${SCRIPT_NAME}.addr

section "Select Script UTxO"
getInputTx ${SCRIPT_NAME} $USER_WALLET
SCRIPT_UTXO=$SELECTED_UTXO

section "Select Collateral UTxO"
getInputTx fees
COLLATERAL_TX=$SELECTED_UTXO
SIGNING_WALLET=$SELECTED_WALLET_NAME
FEE_ADDR=$SELECTED_WALLET_ADDR

walletAddress wallet1
TO_ADDR=$WALLET_ADDRESS

$CARDANO_CLI query protocol-parameters --testnet-magic $TESTNET_MAGIC_NUM > params.json

removeTxFiles

$CARDANO_CLI transaction build \
--tx-in ${SCRIPT_UTXO} \
--tx-in-datum-value "${DATUM_VALUE}" \
--tx-in-redeemer-value "${REDEEMER_VALUE}" \
--tx-in-script-file $SCRIPT_FILE \
--tx-in-collateral=${COLLATERAL_TX} \
--change-address=${FEE_ADDR} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out-datum-hash ${DATUM_HASH} \
--out-file tx.build \
--testnet-magic $TESTNET_MAGIC_NUM \
--protocol-params-file "params.json" \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.build \
--signing-key-file ./wallets/${SIGNING_WALLET}.skey \
--testnet-magic $TESTNET_MAGIC_NUM \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM
