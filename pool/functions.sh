function getInputTx() {
	BALANCE_FILE=/tmp/walletBalances.txt
	rm -f $BALANCE_FILE
	$CARDANO_CLI query utxo --address $(cat $PAYMENT_ADDRESS) --mainnet > $BALANCE_FILE
	SELECTED_WALLET_ADDR=$(cat $PAYMENT_ADDRESS)
	cat $BALANCE_FILE
	read -p 'TX Row Number: ' TMP
	TX_ROW_NUM="$(($TMP+2))"
	TX_ROW=$(sed "${TX_ROW_NUM}q;d" $BALANCE_FILE)
	SELECTED_UTXO="$(echo $TX_ROW | awk '{ print $1 }')#$(echo $TX_ROW | awk '{ print $2 }')"
	SELECTED_UTXO_LOVELACE=$(echo $TX_ROW | awk '{ print $3 }')
	echo "ADA held in $SELECTED_UTXO is $SELECTED_UTXO_LOVELACE"
}

function section {
  echo "============================================================================================"
  echo $1
  echo "============================================================================================"
}

function removeTxFiles() {
  rm -f tx.raw
  rm -f tx.signed
}

