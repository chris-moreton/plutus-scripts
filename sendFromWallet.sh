source functions.sh
getInputTx $1
FROM_UTXO=${SELECTED_UTXO}
FROM_WALLET_NAME=${SELECTED_WALLET_NAME}
FROM_WALLET_ADDRESS=${SELECTED_WALLET_ADDR}
FROM_BALANCE=${SELECTED_UTXO_LOVELACE}

read -p 'Lovelace to send: ' LOVELACE_TO_SEND
read -p 'Receiving wallet name: ' TO_WALLET_NAME

TO_WALLET_ADDRESS=$(cat ./wallets/$TO_WALLET_NAME.addr)

$CARDANO_CLI transaction build \
--tx-in ${FROM_UTXO} \
--tx-out ${TO_WALLET_ADDRESS}+${LOVELACE_TO_SEND} \
--change-address=${FROM_WALLET_ADDRESS} \
--testnet-magic ${TESTNET_MAGIC_NUM} \
--out-file tx.build \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.build \
--signing-key-file ./wallets/${FROM_WALLET_NAME}.skey \
--out-file tx.signed

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM

