source functions.sh
section "From Wallet:"
getInputTx
FROM_UTXO=${SELECTED_UTXO}
FROM_WALLET_NAME=${SELECTED_WALLET_NAME}
FROM_WALLET_ADDRESS=${SELECTED_WALLET_ADDR}
FROM_BALANCE=${SELECTED_UTXO_LOVELACE}

read -p 'Token Amount to send: ' TOKEN_AMOUNT_TO_SEND
read -p 'Token Name: ' TOKEN_NAME
read -p 'Receiving wallet name: ' TO_WALLET_NAME

TO_WALLET_ADDRESS=$(cat ./wallets/$TO_WALLET_NAME.addr)

let TOKEN_CHANGE=$SELECTED_UTXO_TOKENS-$TOKEN_AMOUNT_TO_SEND

$CARDANO_CLI transaction build \
--tx-in ${FROM_UTXO} \
--tx-out ${TO_WALLET_ADDRESS}+10000000+"${TOKEN_AMOUNT_TO_SEND} $TOKEN_NAME" \
--tx-out ${FROM_WALLET_ADDRESS}+10000000+"${TOKEN_CHANGE} $TOKEN_NAME" \
--change-address=${FROM_WALLET_ADDRESS} \
--testnet-magic ${TESTNET_MAGIC_NUM} \
--out-file tx.build \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.build \
--signing-key-file ./wallets/${FROM_WALLET_NAME}.skey \
--out-file tx.signed

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM

