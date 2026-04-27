#!/usr/bin/env bash

# Script to rotate the Ansible vault password file and rekey all vault files with the new password.
# 2026-04-27 -- walther_denis@gmx.de

set -eou pipefail

# VARIABLES SET IN CONFIG
VAULT_INSTANCE=''
BACKEND_PATH=''
IAC_DIRECTORY=''

# TMP (can be overriden by the user config file if needed, but should be set to a safe location where the vault password files can be stored temporarily)
TMP='/tmp'

# OTHER VARIABLES
USER_CONFIG_FILE="${HOME}/.ansible_rekey.conf"
VAULT_CURRENT_PASSWORD_FILE="${TMP}/.current_vault_password.txt"
VAULT_NEW_PASSWORD_FILE="${TMP}/.new_vault_password.txt"

# FUNCTIONS
# Print the usage of the script
function print_usage() {
    echo ''
    echo "Usage: $0 [OPTIONS]"
    echo ''
    echo 'This script is used to rotate the Ansible vault password file and rekey all vault files with the new password.'
    echo ''
    echo 'OPTIONS:'
    echo '  -c  Clean up the current and new vault password files. Use this option if you only ran the rotation but not the rekeying, so that you can remove the password files that are no longer needed.'
    echo '  -h  Show this help message and exit'
    echo '  -r  Rotate the vault password by fetching the current password, generating a new one (passwords will be compared for verification).'
    echo '  -k  Rekey all vaulted files in the inventory directory with the new vault password.'
    echo ''
}

function read_user_config() {
    if [[ -f "${USER_CONFIG_FILE}" ]]; then
        # shellcheck source=/dev/null
        source "${USER_CONFIG_FILE}"
    else
        echo "ERROR: User configuration file ${USER_CONFIG_FILE} not found. Please create it and set the necessary variables."
        exit 1
    fi
}

# Check if located in the correct directory (check for inventory folder in our ansible repo to avoid accidents)
function check_directory() {
    cd "${IAC_DIRECTORY}" || exit 1
    if [[ ! -d 'inventory' ]] && [[ ! -f 'ansible.cfg' ]]; then
        echo 'ERROR: This script must be run from the main ansible directory where the inventory directory is located.'
        exit 1
    fi
}

# Set the VAULT_ADDR environment variable based on the specified environment (live or prelive)
function set_environment() {
    if [[ "${VAULT_INSTANCE}" == 'https://live-vault.example.com' ]]; then
        # Ask the user to confirm that they want to continue working on the live vault
        read -r -p "You are currently working on the live vault: ${VAULT_INSTANCE}. Do you want to continue? (y/n) " CONTINUE
        if [[ "${CONTINUE}" != "y" ]]; then
            echo "Aborting script execution."
            exit 0
        fi
    elif [[ "${VAULT_INSTANCE}" == 'https://prelive-vault.example.com' ]]; then
        echo "Working on the prelive vault: ${VAULT_INSTANCE}"
    else
        echo "ERROR: VAULT_INSTANCE is set to an unknown value. Please ensure it is set in ${USER_CONFIG_FILE}."
        exit 1
    fi
}

# Check if logged into the vault - if not, quit with an error message
function check_vault_login() {
    if ! (vault token lookup >/dev/null 2>&1); then
        echo 'ERROR: Not logged in into vault. Please login manually first like this:'
        echo 'vault login -method=ldap'
        exit 1
    fi
}

# Fetch the vault password from the vault and store it in the current vault password file
function fetch_vault_password() {
    local VAULT_RESULT
    if ! VAULT_RESULT=$(vault kv get -field=password "${BACKEND_PATH}" 2>/dev/null); then
        echo 'ERROR: Failed to fetch the vault password from vault. Please check if the path is correct and if you have the necessary permissions.'
        exit 1
    fi
    echo "${VAULT_RESULT}" > "${VAULT_CURRENT_PASSWORD_FILE}"
    echo "Vault password fetched and stored in ${VAULT_CURRENT_PASSWORD_FILE}"
}

function generate_new_vault_password() {
    local NEW_PASSWORD
    NEW_PASSWORD=$(openssl rand -base64 128 | tr -dc 'a-zA-Z0-9' | head -c 64 || true)
    # Generate a new random password and store it in the new vault password file (64 characters long, alphanumeric)
    if ! vault kv put "${BACKEND_PATH}" password="${NEW_PASSWORD}" > /dev/null; then
        echo 'ERROR: Failed to generate a new vault password. Please check if the path is correct and if you have the necessary permissions.'
        exit 1
    fi
    echo "${NEW_PASSWORD}" > "${VAULT_NEW_PASSWORD_FILE}"
    echo "New vault password generated and stored in ${VAULT_NEW_PASSWORD_FILE}"
}

function compare_vault_passwords() {
    if ! diff -q "${VAULT_CURRENT_PASSWORD_FILE}" "${VAULT_NEW_PASSWORD_FILE}" >/dev/null 2>&1; then
        echo "OK: Vault passwords are different. You can now proceed with rekeying."
    else
        echo "ERROR: Vault passwords are the same. Something went wrong with generating the new vault password!"
        exit 1
    fi
}

function rekey_vault_files() {
    # Ask the user to confirm that they want to continue with rekeying the vault files
    read -r -p "Do you want to continue with rekeying the vault files with the new vault password? (y/n) " CONTINUE
    if [[ "${CONTINUE}" != "y" ]]; then
        echo "You said no. I will exit here."
        exit 0
    fi
    # Find and rekey all vaulted files in the inventory directory using the current and new vault password files
    grep -rl "\$ANSIBLE_VAULT" inventory/* | while read -r VAULTED_FILE; do
        .venv/bin/ansible-vault rekey --vault-id default@"${VAULT_CURRENT_PASSWORD_FILE}" --new-vault-id default@"${VAULT_NEW_PASSWORD_FILE}" "${VAULTED_FILE}"
        echo "Rekeyed ${VAULTED_FILE} with the new vault password."
    done
    echo 'Rekeying completed.'
}

function print_git_status() {
    echo ''
    echo 'The following files have been modified:'
    cd "${IAC_DIRECTORY}" || exit 1
    git status -s | cut -d '?' -f3
    echo ''
    echo 'Please review the changes and commit them to your branch.'
    echo ''
}

function cleanup() {
    # Remove the current and new vault password files
    rm -f "${VAULT_CURRENT_PASSWORD_FILE}" "${VAULT_NEW_PASSWORD_FILE}"
    echo "Cleaned up vault password files: ${VAULT_CURRENT_PASSWORD_FILE} and ${VAULT_NEW_PASSWORD_FILE}"
}

# If no arguments were provided, show help and exit
if [[ $# -eq 0 ]]; then
    print_usage
    exit 0
fi

while getopts "chkr" opt; do
    case ${opt} in
        c)
            # In case you only ran rotation but not rekeying, you can use this option to just clean up the password files
            cleanup
            exit 0
            ;;
        r)
            read_user_config
            set_environment
            check_vault_login
            fetch_vault_password
            generate_new_vault_password
            compare_vault_passwords
            # cleanup will be done after rekeying, so that the password files are still available for the rekeying process
            exit 0
            ;;
        k)
            read_user_config
            set_environment
            check_vault_login
            check_directory
            rekey_vault_files
            print_git_status
            cleanup
            exit 0
            ;;
        h)
            print_usage
            exit 0
            ;;
        *)
            print_usage
            exit 1
            ;;
    esac
done
