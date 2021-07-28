TXHASH=$1
TXINDEX=$2
BALANCE=$3
FEE=$5
PAYMENT="$(($4-$FEE))"
FROM_ADDR=$(cat ~/wallets/${6}.addr)
TO_ADDR=$(cat ~/wallets/${7}.addr)
SLOT=$(./currentSlot.sh)
TX=${TXHASH}#${TXINDEX}
CHANGE="$(($BALANCE-$PAYMENT-$FEE))"
TTL_PLUS="$(($SLOT+30))"

$CARDANO_CLI transaction build-raw \
--tx-in ${TX} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out ${FROM_ADDR}+${CHANGE} \
--ttl ${TTL_PLUS} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ~/wallets/$6.skey \
--testnet-magic 7 \
--out-file tx.signed

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic 7

