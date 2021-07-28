function getInputTx() {
	BALANCE_FILE=/tmp/walletBalances.txt
	rm $BALANCE_FILE
	read -p 'Wallet Name: ' TX_WALLET_NAME
	./balance.sh $TX_WALLET_NAME > $BALANCE_FILE
	TX_WALLET_ADDR=$(cat ./wallets/$TX_WALLET_NAME.addr)
	cat $BALANCE_FILE
	read -p 'TX Row Number: ' TMP
	TX_ROW_NUM="$(($TMP+2))"
	TX_ROW=$(sed "${TX_ROW_NUM}q;d" $BALANCE_FILE)
	INPUT_UTXO="$(echo $TX_ROW | awk '{ print $1 }')#$(echo $TX_ROW | awk '{ print $2 }')"
	TX_BALANCE=$(echo $TX_ROW | awk '{ print $3 }')
	echo "ADA held in $INPUT_UTXO is $TX_BALANCE"
}

