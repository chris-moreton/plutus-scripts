$CARDANO_CLI query utxo --address $(cat paymentwithstake.addr) --testnet-magic $TESTNET_MAGIC_NUM

# Create transaction draft
$CARDANO_CLI transaction build-raw --tx-in 500c11b65020cefe9227719ea0d7a2d249c6719b24380949ff433c7d8f949399#0 --tx-out $(cat paymentwithstake.addr)+1000000000000 --fee 0 --out-file tx_stake.raw --certificate-file stake.cert

# Calculate fee
$CARDANO_CLI transaction calculate-min-fee --tx-body-file tx_stake.raw --tx-in-count 1 --tx-out-count 1 --witness-count 1 --testnet-magic $TESTNET_MAGIC_NUM --protocol-params-file protocol.json

# Calculate change (2 ada must be deposited for staking cert)
expr 1000000000000 - 172849 - 2000000

# Final transaction
$CARDANO_CLI transaction build-raw --tx-in 500c11b65020cefe9227719ea0d7a2d249c6719b24380949ff433c7d8f949399#0 --tx-out $(cat paymentwithstake.addr)+999997827151 --fee 172849 --out-file tx_stake.raw --certificate-file stake.cert

# Sign
$CARDANO_CLI transaction sign --tx-body-file tx_stake.raw --signing-key-file stake.skey --signing-key-file payment.skey --testnet-magic $TESTNET_MAGIC_NUM --out-file tx_stake.signed

# Submit
$CARDANO_CLI transaction submit --tx-file tx_stake.signed --testnet-magic $TESTNET_MAGIC_NUM
