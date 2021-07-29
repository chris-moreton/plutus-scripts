#!/bin/bash
$CARDANO_CLI query tip --mainnet | jq -r '.slot'

