TX=${TXHASH}#${TXINDEX}
cardano-cli transaction build-raw \
--tx-in ${SELECTED_UTXO} \
--tx-out ${SELECTED_WALLET_ADDR}+0 \
--ttl 0 \
--fee 0 \
--out-file tx.draft \
--certificate-file pool-registration.cert \
--certificate-file delegation.cert

