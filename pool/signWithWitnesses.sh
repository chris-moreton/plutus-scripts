## operator witness - Signed by pool operator (payer of pool deposit and fees) 
cardano-cli shelley transaction witness \
--tx-body-file tx.raw \
--signing-key-file $WALLET_LOCATION.skey \
--mainnet \
--out-file operator.witness

## pool witness - signed by pool's cold key.
cardano-cli shelley transaction witness \
--tx-body-file tx.raw \
--signing-key-file cold.skey \
--mainnet \
--out-file pool.witness

cardano-cli transaction assemble \
--tx-body-file tx.raw \
--witness-file operator.witness \
--witness-file pool.witness \
--witness-file owner.witness \
--out-file tx.signed

