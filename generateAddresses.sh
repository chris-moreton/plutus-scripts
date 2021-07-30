cd wallets
$CARDANO_CLI address key-gen --verification-key-file main.vkey --signing-key-file main.skey
$CARDANO_CLI address key-gen --verification-key-file wallet1.vkey --signing-key-file wallet1.skey
$CARDANO_CLI address key-gen --verification-key-file wallet2.vkey --signing-key-file wallet2.skey
$CARDANO_CLI address key-gen --verification-key-file wallet3.vkey --signing-key-file wallet3.skey
$CARDANO_CLI address key-gen --verification-key-file collateral.vkey --signing-key-file collateral.skey
$CARDANO_CLI address key-gen --verification-key-file fees.vkey --signing-key-file fees.skey
$CARDANO_CLI stake-address key-gen --verification-key-file stake1.vkey --signing-key-file stake1.skey
$CARDANO_CLI stake-address key-gen --verification-key-file stake2.vkey --signing-key-file stake2.skey
$CARDANO_CLI stake-address key-gen --verification-key-file stake3.vkey --signing-key-file stake3.skey

$CARDANO_CLI address build --payment-verification-key-file main.vkey --out-file main.addr --testnet-magic $TESTNET_MAGIC_NUM
$CARDANO_CLI address build --payment-verification-key-file wallet1.vkey --stake-verification-key-file stake1.vkey --out-file wallet1.addr --testnet-magic $TESTNET_MAGIC_NUM
$CARDANO_CLI address build --payment-verification-key-file wallet2.vkey --stake-verification-key-file stake2.vkey --out-file wallet2.addr --testnet-magic $TESTNET_MAGIC_NUM
$CARDANO_CLI address build --payment-verification-key-file wallet3.vkey --stake-verification-key-file stake3.vkey --out-file wallet3.addr --testnet-magic $TESTNET_MAGIC_NUM
$CARDANO_CLI address build --payment-verification-key-file collateral.vkey --out-file collateral.addr --testnet-magic $TESTNET_MAGIC_NUM
$CARDANO_CLI address build --payment-verification-key-file fees.vkey --out-file fees.addr --testnet-magic $TESTNET_MAGIC_NUM
