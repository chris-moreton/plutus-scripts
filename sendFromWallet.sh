source functions.sh
getInputTx $1
FROM_UTXO=${SELECTED_UTXO}
FROM_WALLET_NAME=${SELECTED_WALLET_NAME}
FROM_WALLET_ADDRESS=${SELECTED_WALLET_ADDR}
FROM_BALANCE=${SELECTED_UTXO_LOVELACE}

read -p 'Lovelace to send: ' LOVELACE_TO_SEND
read -p 'Receiving wallet name: ' TO_WALLET_NAME

TO_WALLET_ADDRESS=$(cat ./wallets/$TO_WALLET_NAME.addr)

FEE=200000
SLOT=$(./currentSlot.sh)
CHANGE="$(($FROM_BALANCE-$LOVELACE_TO_SEND-$FEE))"

$CARDANO_CLI transaction build-raw \
--tx-in ${FROM_UTXO} \
--tx-out ${TO_WALLET_ADDRESS}+${LOVELACE_TO_SEND} \
--tx-out ${FROM_WALLET_ADDRESS}+${CHANGE} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ./wallets/$FROM_WALLET_NAME.skey \
--out-file tx.signed

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM

