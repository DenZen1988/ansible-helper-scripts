#!/usr/bin/env bash

# Script to fetch the ansible-vault password from a desired hashicorp vault.
# This script is used by ansible to get the vault password when needed.
# 2026-04-23 -- walther_denis@gmx.de

set -euo pipefail

# Define the path to the vault secret where the ansible-vault password is stored
BACKEND_PATH='path/to/secrets/ansible_vault'

function check_environment() {
    # Check if VAULT_ADDR environment variable is set - if not, quit with an error message
    : "${VAULT_ADDR:?Error: VAULT_ADDR environment variable is not set}"
    # If not logged into the desired vault - quit with an error message
    if [[ "${VAULT_ADDR}" != "https://live-vault.example.com" ]]; then
        echo 'ERROR: Not using the desired vault. Please ensure working only with the desired vault!'
        echo "Current VAULT_ADDR: ${VAULT_ADDR}"
        exit 1
    fi
}

# Check if logged into the vault - if not, quit with an error message
function check_vault_login() {
    if ! (vault token lookup >/dev/null 2>&1); then
        echo 'Not logged in into vault. Please login manually first like this:'
        echo 'vault login -method=your_method'
        exit 1
    fi
}

# Fetch the vault password from the vault and print it to stdout
function fetch_vault_password() {
    local VAULT_RESULT
    if ! VAULT_RESULT=$(vault kv get -field=password "${BACKEND_PATH}" 2>/dev/null); then
        echo 'ERROR: Failed to fetch the vault password from vault. Please check if the path is correct and if you have the necessary permissions.'
        exit 1
    fi
    echo "${VAULT_RESULT}"
}
function main() {
    check_environment
    check_vault_login
    fetch_vault_password
}

# Check if sourced or executed directly, and only run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
