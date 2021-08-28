mkdir -p policies

OWNER_WALLET_NAME=$1
POLICY_SCRIPT=policies/$OWNER_WALLET_NAME.script

$CARDANO_CLI address key-gen \
    --verification-key-file policies/$OWNER_WALLET_NAME.vkey \
    --signing-key-file policies/$OWNER_WALLET_NAME.skey


touch $POLICY_SCRIPT && echo "" > $POLICY_SCRIPT


echo "{" >> $POLICY_SCRIPT 
echo "  \"keyHash\": \"$($CARDANO_CLI address key-hash --payment-verification-key-file policies/$OWNER_WALLET_NAME.vkey)\"," >> $POLICY_SCRIPT
echo "  \"type\": \"sig\"" >> $POLICY_SCRIPT
echo "}" >> $POLICY_SCRIPT


