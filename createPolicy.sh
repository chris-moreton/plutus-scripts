mkdir -p policies

cd policies

$CARDANO_CLI address key-gen \
    --verification-key-file $1.vkey \
    --signing-key-file $1.skey


touch $1.script && echo "" > $1.script 


echo "{" >> $1.script 
echo "  \"keyHash\": \"$($CARDANO_CLI address key-hash --payment-verification-key-file $1.vkey)\"," >> $1.script 
echo "  \"type\": \"sig\"" >> $1.script 
echo "}" >> $1.script 


