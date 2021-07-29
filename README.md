Quick and Dirty Alonzo White Bash Scripts
=========================================

These are my helper scripts while working with the Alonzo White testnet.

Setup
-----

Put all .addr files and their associated .skey files in ./wallets and all Plutus scripts in ./scripts.

Set environment variables

	export CARDANO_CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli
        export TESTNET_MAGIC_NUM=7

Functions file
--------------

The various scripts use the functions.sh file. One of the functions in that file is called *getInputTx* and
which will prompt the user for a wallet name and then ask them to select a UTxO. Various environment variables are then set
which can be used in writing scripts.

    SELECTED_UTXO (Hash#Index)
    SELECTED_WALLET_ADDR
    SELECTED_UTXO_LOVELACE
    SELECTED_WALLET_NAME

Some Helpers
------------

Gets the UTxOs sitting at the address of the ./scripts/AlwaysSucceeds.plutus script.

	./contractBalance.sh AlwaysSucceeds

Gets the balance of the address in ~/wallets/mywallet.addr

	./balance.sh mywallet

Pay to smart contract. This will prompt for a wallet and transaction. Arguments are payment, fee, script name and datum.

	./payToScript.sh 1010011010 200000 AlwaysSucceeds 6666

Get from smart contract. This will prompt for a script UTxO and a collateral UTxO. Arguments are the same as for payToScript.sh.

	./getFromScript.sh 10000000 110174521 AlwaysSucceeds 6666

