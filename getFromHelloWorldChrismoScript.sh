source functions.sh

##########################################################
# Set these if you don't have them set globally
# TESTNET_MAGIC_NUM=
# CARDANO_CLI=
##########################################################
# Put all xxxx.addr files in ./wallets
# Put all xxxx.skey files in ~/wallets
# xxxx is the name of the wallet you give when prompted
##########################################################

SCRIPT_NAME="HelloWorldChrismo"
section "Select Script UTxO"
getInputTx ${SCRIPT_NAME}
SCRIPT_UTXO=$SELECTED_UTXO

read -p 'Lovelace to get from script: ' PAYMENT

SCRIPT_CHANGE="$(($SELECTED_UTXO_LOVELACE-$PAYMENT))"

SCRIPT_FILE=./scripts/${SCRIPT_NAME}.plutus

read -p 'Datum: ' DATUM_VALUE
read -p 'Redeemer: ' REDEEMER_VALUE

DATUM_HASH=$(cardano-cli transaction hash-script-data --script-data-value "$DATUM_VALUE")
SCRIPT_ADDRESS=$(cardano-cli address build --payment-script-file $SCRIPT_FILE --testnet-magic $TESTNET_MAGIC_NUM)
echo $SCRIPT_ADDRESS > ./wallets/${SCRIPT_NAME}.addr

FEE_WALLET=collateral

section "Select Collateral UTxO"
getInputTx $FEE_WALLET
COLLATERAL_TX=$SELECTED_UTXO
TO_ADDR=$SELECTED_WALLET_ADDR

section "Select Fees UTxO"
getInputTx $FEE_WALLET
FEE_UTXO=$SELECTED_UTXO
FEE=76380441
FEE_CHANGE="$(($SELECTED_UTXO_LOVELACE-$FEE))"
FEE_ADDR=$SELECTED_WALLET_ADDR

SIGNING_WALLET=$FEE_WALLET

$CARDANO_CLI query protocol-parameters --testnet-magic $TESTNET_MAGIC_NUM > params.json

removeTxFiles

if (($FEE_CHANGE <= 0)); then
	echo "Fee UTxO too small"
	exit
fi


$CARDANO_CLI transaction build-raw \
--tx-in ${SCRIPT_UTXO} \
--tx-in-datum-value "${DATUM_VALUE}" \
--tx-in-redeemer-value "$REDEEMER_VALUE" \
--tx-in-script-file $SCRIPT_FILE \
--tx-in-execution-units "(6000000000, 6000000000)" \
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
--signing-key-file ~/wallets/${SIGNING_WALLET}.skey \
--testnet-magic $TESTNET_MAGIC_NUM \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM



