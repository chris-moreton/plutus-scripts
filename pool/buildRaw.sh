cardano-cli transaction build-raw \
--tx-in ${TX} \
--tx-out ${SELECTED_WALLET_ADDR}+${CHANGE} \
--ttl ${TTL_PLUS} \
--fee ${FEE} \
--out-file tx.raw \
--certificate-file pool-registration.cert

