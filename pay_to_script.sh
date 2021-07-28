CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli
TXHASH=$1
TXINDEX=$2
FROM_ADDR=$(cat wallet.addr)
SLOT=$(./currentSlot.sh)
FEE=$5
BALANCE=$3
PAYMENT=$(($4))
TX=${TXHASH}#${TXINDEX}
CHANGE="$(($BALANCE-$PAYMENT-$FEE))"
TTL_PLUS="$(($SLOT+30))"
SCRIPT_ADDRESS=$(cardano-cli address build --payment-script-file $7 --testnet-magic 7)
DATUM_HASH=$(cardano-cli transaction hash-script-data --script-data-value $6)
TO_ADDR=$SCRIPT_ADDRESS

$CLI transaction build-raw \
--tx-in ${TX} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out-datum-hash ${DATUM_HASH} \
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
