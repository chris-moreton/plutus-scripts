### ./burn.sh minter Chess 100 wallet2

source functions.sh

POLICY_NAME=$1
COIN_NAME=$2
let TOKEN_COUNT=$3*1000000
echo $TOKEN_COUNT
MINT_WALLET_NAME=$4

if [ ! -f "./policies/$POLICY_NAME.script" ]; then
    ./createPolicy.sh $POLICY_NAME
fi

POLICY_ID=$($CARDANO_CLI transaction policyid --script-file ./policies/$POLICY_NAME.script)

getInputTx $MINT_WALLET_NAME
FROM_UTXO=${SELECTED_UTXO}
FROM_WALLET_NAME=${SELECTED_WALLET_NAME}
FROM_WALLET_ADDRESS=${SELECTED_WALLET_ADDR}
let REMAINING_TOKEN_COUNT=$SELECTED_UTXO_TOKENS-$TOKEN_COUNT

$CARDANO_CLI transaction build \
--tx-in ${FROM_UTXO} \
--tx-out ${FROM_WALLET_ADDRESS}+$TOKEN_COUNT+"$REMAINING_TOKEN_COUNT ${POLICY_ID}.${COIN_NAME}" \
--change-address=${FROM_WALLET_ADDRESS} \
--mint="-$TOKEN_COUNT ${POLICY_ID}.${COIN_NAME}" \
--mint-script-file="./policies/$POLICY_NAME.script" \
--testnet-magic ${TESTNET_MAGIC_NUM} \
--out-file tx.build \
--witness-override 2 \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.build \
--signing-key-file ./wallets/${FROM_WALLET_NAME}.skey \
--signing-key-file ./wallets/${POLICY_NAME}.skey \
--out-file tx.signed

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic $TESTNET_MAGIC_NUM

