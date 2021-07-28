TXHASH=$1
TXINDEX=$2
FROM_ADDR=$(cat payment.addr)
TO_ADDR=$(cat wallet.addr)
SLOT=$(./currentSlot.sh)
FEE=$5
BALANCE=$3
PAYMENT="$(($4-$FEE))"
TX=${TXHASH}#${TXINDEX}
CHANGE="$(($BALANCE-$PAYMENT-$FEE))"
TTL_PLUS="$(($SLOT+30))"

cardano-cli transaction build-raw \
--tx-in ${TX} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out ${FROM_ADDR}+${CHANGE} \
--ttl ${TTL_PLUS} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

cardano-cli transaction sign \
--tx-body-file tx.raw \
--signing-key-file payment.skey \
--testnet-magic 7 \
--out-file tx.signed

cardano-cli transaction submit --tx-file tx.signed --testnet-magic 7

