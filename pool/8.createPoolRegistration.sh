# get metadata hash
cardano-cli stake-pool metadata-hash --pool-metadata-file pool-metadata-euro.json
> ab850709ce456fb39fac6bc5fa18ef2c86c53e0d6720d5b4e5ca3a493577b71e

# create pool-registration cert
cardano-cli stake-pool registration-certificate --cold-verification-key-file cold.vkey --vrf-verification-key-file vrf.vkey --pool-pledge 900000000000 --pool-cost 340000000 --pool-margin 0 --pool-reward-account-verification-key-file stake.vkey --pool-owner-stake-verification-key-file stake.vkey --testnet-magic 8 --pool-relay-ipv4 49.12.86.157 --pool-relay-port 3007 --metadata-url https://cardano-tools.io/pool-metadata-euro.json --metadata-hash ab850709ce456fb39fac6bc5fa18ef2c86c53e0d6720d5b4e5ca3a493577b71e --out-file pool-registration.cert

# create delegation cert for pledge
cardano-cli stake-address delegation-certificate --stake-verification-key-file stake.vkey --cold-verification-key-file cold.vkey --out-file delegation.cert

# Submit certs
cardano-cli query utxo --address $(cat paymentwithstake.addr) --testnet-magic 8
> 999997827151

cardano-cli transaction build-raw --tx-in 05b8a9b7accaaafd541ae43f792d12f8f525bb2151460a37c08ff343663f8c42#0 --tx-out $(cat paymentwithstake.addr)+999997827151 --fee 0 --out-file tx_pool.raw --certificate-file pool-registration.cert --certificate-file delegation.cert

# Calculate fee
cardano-cli transaction calculate-min-fee --tx-body-file tx_stake.raw --tx-in-count 1 --tx-out-count 1 --witness-count 1 --testnet-magic 8 --protocol-params-file protocol.json
> 173025 Lovelace

# Calculate change (500 ada must be deposited for pool registration)
expr 999997827151 - 187677 - 500000000
> 999497639474

# build final transaction
cardano-cli transaction build-raw --tx-in 05b8a9b7accaaafd541ae43f792d12f8f525bb2151460a37c08ff343663f8c42#0 --tx-out $(cat paymentwithstake.addr)+999497639474 --fee 187677 --out-file tx_pool.raw --certificate-file pool-registration.cert --certificate-file delegation.cert

# Sign
cardano-cli transaction sign --tx-body-file tx_pool.raw --signing-key-file payment.skey --signing-key-file stake.skey --signing-key-file cold.skey --testnet-magic 8 --out-file tx_pool.signed

# Submit, when submit fails just use the fee from the error meesage and create/sign TX again
cardano-cli transaction submit --tx-file tx_pool.signed --testnet-magic 8

# Check if pool is registred
cardano-cli stake-pool id --cold-verification-key-file cold.vkey --output-format hex
cardano-cli stake-pool id --cold-verification-key-file cold.vkey

# Check rewards
cardano-cli query stake-distribution --testnet-magic 8 > stake-distribution.json
cardano-cli query ledger-state --testnet-magic 8 > ledger-state.json
cardano-cli query stake-address-info --testnet-magic 8 --address $(cat stake.addr)

