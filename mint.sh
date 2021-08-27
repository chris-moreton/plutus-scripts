source functions.sh

COIN_NAME=$1

./createPolicy.sh $COIN_NAME

POLICY_ID=$($CARDANO_CLI transaction policyid --script-file ./policies/$COIN_NAME.script)

getInputTx main
FROM_UTXO=${SELECTED_UTXO}
FROM_WALLET_NAME=${SELECTED_WALLET_NAME}
FROM_WALLET_ADDRESS=${SELECTED_WALLET_ADDR}

$CARDANO_CLI transaction build \
--tx-in ${FROM_UTXO} \
--tx-out ${FROM_WALLET_ADDRESS}+100000000+"100000000 ${POLICY_ID}" \
--change-address=${FROM_WALLET_ADDRESS} \
--mint="100000000 ${POLICY_ID}" \
--mint-script-file="./policies/$COIN_NAME.script" \
--testnet-magic ${TESTNET_MAGIC_NUM} \
--out-file tx.build \
--witness-override 2 \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.build \
--signing-key-file ./wallets/${FROM_WALLET_NAME}.skey \
--signing-key-file ./policies/${COIN_NAME}.skey \
--out-file tx.signed

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM

