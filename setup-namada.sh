#!/usr/bin/env bash

OLD_CHAIN_ID=$(ls -1 localnet.*.tar.gz | sed -E 's/(localnet\..*)\.tar\.gz/\1/')

rm -r ~/.local/share/namada/* ./localnet.*.tar.gz

if [[ "$1" == "--build" ]]
then
    make build-wasm-scripts
    make build-release
fi

NAMADA_BASE_DIR=localnet ./target/release/namadac utils init-network --chain-prefix localnet --genesis-time "2023-08-30T00:00:00.000000000+00:00" --templates-path genesis/localnet --wasm-checksums-path wasm/checksums.json --consensus-timeout-commit 8200ms

CHAIN_ID=$(ls -1 localnet.*.tar.gz | sed -E 's/(localnet\..*)\.tar\.gz/\1/')

NAMADA_NETWORK_CONFIGS_DIR=. ./target/release/namadac utils join-network --chain-id $CHAIN_ID --genesis-validator validator-0 --pre-genesis-path genesis/localnet/src/pre-genesis/validator-0 --dont-prefetch-wasm

echo "Fixing CORS"
find ~/.local/share/namada/$CHAIN_ID -type f -name "config.toml" -exec sed -i -E "s/cors_allowed_origins[[:space:]]=[[:space:]]\[\]/cors_allowed_origins = [\"*\"]/g" {} +

echo "Copying WASMs"
cp wasm/*.wasm ~/.local/share/namada/localnet.*/wasm

echo "Writing .env files"
find ~/src/namada-interface -type f -path '*/apps/namadillo/.env' -exec sed -i -E "s/^(NAMADA_INTERFACE_NAMADA_CHAIN_ID=).*$/\1$CHAIN_ID/" {} +

echo "Deriving accounts"
./derive.exp
./derive-relayer.exp

if [[ "$OLD_CHAIN_ID" != "$CHAIN_ID" ]]
then
    echo ""
    echo "NEW CHAIN ID!!!"
fi
