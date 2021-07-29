source functions.sh
getScriptAddress HelloWorld

section "Fee UTxO"
getInputTx fees
FEE_UTXO=$SELECTED_UTXO
FEE_ADDRESS=$SELECTED_WALLET_ADDR
FEE_BALANCE=$SELECTED_UTXO_LOVELACE
FEE_WALLET_NAME=$SELECTED_WALLET_NAME

section "Collateral UTxO"
getInputTx collateral
COLLATERAL_UTXO=$SELECTED_UTXO
COLLATERAL_WALLET_NAME=$SELECTED_WALLET_NAME

FEE=600000000
FEE_CHANGE=$(($FEE_BALANCE-$FEE))

DATUM_VALUE=42
setDatumHash
REDEEMER_VALUE=0

$CARDANO_CLI transaction build-raw \
--tx-in ${FEE_UTXO} \
--tx-in-collateral=${COLLATERAL_UTXO} \
--fee ${FEE} \
--tx-out ${FEE_ADDRESS}+${FEE_CHANGE} \
--tx-out ${SCRIPT_ADDRESS}+66000000
--tx-out-datum-hash ${DATUM_HASH} \
--out-file tx.raw \
--protocol-params-file "params.json" \
--alonzo-era

$CARDANO_CLI transaction witness \
--tx-body-file tx.raw \
--signing-key-file ~/wallets/${FEE_WALLET_NAME}.skey \
--testnet-magic $TESTNET_MAGIC_NUM \
--out-file /tmp/fee.witness

$CARDANO_CLI transaction witness \
--tx-body-file tx.raw \
--signing-key-file ~/wallets/${COLLATERAL_WALLET_NAME}.skey \
--testnet-magic $TESTNET_MAGIC_NUM \
--out-file /tmp/collateral.witness

$CARDANO_CLI transaction assemble \
--tx-body-file tx.raw \
--witness-file /tmp/fee.witness \
--witness-file /tmp/collateral.witness \
--out-file tx.signed

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM
