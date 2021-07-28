CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli
TXHASH=$1
TXINDEX=$2
BALANCE=$3
PAYMENT=$4
FEE=$5
DATUM_VALUE=$6
COLLATERALHASH=$7
COLLATERALINDEX=$8
SCRIPT_FILE=$9
COLLATERALTX=${COLLATERALHASH}#${COLLATERALINDEX}
DATUM_HASH=$(cardano-cli transaction hash-script-data --script-data-value $DATUM_VALUE)
SCRIPT_ADDRESS=$(cardano-cli address build --payment-script-file $SCRIPT_FILE --testnet-magic 7)
TX=${TXHASH}#${TXINDEX}
SLOT=$(./currentSlot.sh)
FROM_ADDR=$SCRIPT_ADDRESS
CHANGE="$(($BALANCE-$PAYMENT-$FEE))"
TTL_PLUS="$(($SLOT+30))"
TO_ADDR=$(cat wallet.addr)

$CARDANO_CLI query protocol-parameters --testnet-magic 7 > params.json

$CLI transaction build-raw \
--tx-in ${TX} \
--tx-in-datum-value $DATUM_VALUE \
--tx-in-redeemer-value 0 \
--tx-in-script-file $SCRIPT_FILE \
--tx-in-execution-units "(10000000000, 10000000000)" \
--tx-in-collateral=${COLLATERALTX} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--protocol-params-file "params.json" \
--tx-out ${FROM_ADDR}+${CHANGE} \
--ttl ${TTL_PLUS} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

$CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file wallet.skey \
--testnet-magic 7 \
--out-file tx.signed \

$CLI transaction submit --tx-file tx.signed --testnet-magic 7

