BALANCE_FILE=/tmp/walletBalances.txt
rm $BALANCE_FILE
read -p 'Wallet Name: ' TX_WALLET
./balance.sh $TX_WALLET > $BALANCE_FILE
cat $BALANCE_FILE
read -p 'TX Row Number: ' TMP
TX_ROW_NUM="$(($TMP+2))"
TX_ROW=$(sed "${TX_ROW_NUM}q;d" $BALANCE_FILE)
UTXO=$(echo $TX_ROW | awk '{ print $1 }')#$(echo $TX_ROW | awk '{ print $2 }')
TX_BALANCE=$(echo $TX_ROW | awk '{ print $3 }')
echo "ADA held in $UTXO is $TX_BALANCE"

