TXHASH=$1
TXINDEX=$2
FROM_ADDR=$(cat ~/wallets/${8}.addr)
SLOT=$(./currentSlot.sh)
FEE=$5
BALANCE=$3
PAYMENT=$(($4))
TX=${TXHASH}#${TXINDEX}
CHANGE="$(($BALANCE-$PAYMENT-$FEE))"
TTL_PLUS="$(($SLOT+30))"
SCRIPT_ADDRESS=$(cardano-cli address build --payment-script-file ~/scripts/${7}.plutus --testnet-magic 7)
DATUM_HASH=$(cardano-cli transaction hash-script-data --script-data-value $6)
TO_ADDR=$SCRIPT_ADDRESS

$CARDANO_CLI transaction build-raw \
--tx-in ${TX} \
--tx-out ${TO_ADDR}+${PAYMENT} \
--tx-out-datum-hash ${DATUM_HASH} \
--tx-out ${FROM_ADDR}+${CHANGE} \
--ttl ${TTL_PLUS} \
--fee ${FEE} \
--out-file tx.raw \
--alonzo-era

$CARDANO_CLI transaction sign \
--tx-body-file tx.raw \
--signing-key-file ~/wallets/${8}.skey \
--testnet-magic 7 \
--out-file tx.signed \

$CARDANO_CLI transaction submit --tx-file tx.signed --testnet-magic 7

