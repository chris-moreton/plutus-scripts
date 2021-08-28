mkdir -p policies

MINTER_KEY_NAME=$1
POLICY_SCRIPT=policies/$MINTER_KEY_NAME.script

$CARDANO_CLI address key-gen \
    --verification-key-file wallets/$MINTER_KEY_NAME.vkey \
    --signing-key-file wallets/$MINTER_KEY_NAME.skey

touch $POLICY_SCRIPT && echo "" > $POLICY_SCRIPT

echo "{" >> $POLICY_SCRIPT 
echo "  \"keyHash\": \"$($CARDANO_CLI address key-hash --payment-verification-key-file wallets/$MINTER_KEY_NAME.vkey)\"," >> $POLICY_SCRIPT
echo "  \"type\": \"sig\"" >> $POLICY_SCRIPT
echo "}" >> $POLICY_SCRIPT


