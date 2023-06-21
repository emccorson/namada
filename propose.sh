#!/bin/sh

./target/release/namada client init-proposal --data-path proposal.json --gas-limit 60000
./target/release/namada client init-proposal --pgf-stewards --data-path proposal2.json
./target/release/namada client init-proposal --pgf-funding --data-path proposal3.json
