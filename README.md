Quick and Dirty Alonzo White Bash Scripts
=========================================

These are my helper scripts while working with the Alonzo White testnet.

Setup
-----

Put all .addr files and their associated .skey files in ~/wallets

Set the CARDANO_CLI to point to the correct version of cardano-cli.

	export CARDANO_CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli

Functions file
--------------

The various scripts rely on the functions.sh file which currently contains just one function. That function will
prompt the user for a wallet name and then ask them to select a UTxO. Various environment variables are then set
which can be used in writing scripts.

Some Helpers
------------

Gets the UTxOs sitting at the address of the ~/scripts/AlwaysSucceeds.plutus script.

	./contractBalance.sh AlwaysSucceeds

Gets the balance of the address in ~/wallets/mywallet.addr

	./balance.sh mywallet

Pay to smart contract. This will prompt for a wallet and transaction. Arguments are payment, fee, script name and datum.

	./payToScript.sh 1010011010 200000 AlwaysSucceeds 666

Get from smart contract. This will prompt for a script UTxO and a collateral UTxO. Arguments are the same as for payToScript.sh.

	./getFromScript.sh 10000000 110174521 AlwaysSucceeds 6666

