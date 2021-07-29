FILENAME=metadata.json
wget ${METADATA_URL} -O ${FILENAME}
METADATA_HASH=$(cardano-cli stake-pool metadata-hash --pool-metadata-file ${FILENAME})
$CARDANO_CLI stake-pool registration-certificate \
--cold-verification-key-file $COLD_VKEY \
--vrf-verification-key-file $VRF_VKEY \
--pool-pledge ${PLEDGE} \
--pool-cost ${COST} \
--pool-margin ${MARGIN} \
--pool-reward-account-verification-key-file $STAKE_VKEY \
--pool-owner-stake-verification-key-file $STAKE_VKEY \
--mainnet \
--single-host-pool-relay ${RELAY_IP} \
--pool-relay-port ${RELAY_PORT} \
--metadata-url ${METADATA_URL} \
--metadata-hash ${METADATA_HASH} \
--out-file pool-registration.cert

