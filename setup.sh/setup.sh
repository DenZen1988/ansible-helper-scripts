#!/usr/bin/env bash

# Script to setup my virtual environment for Ansible development on my MacBook.
# 2026-04-17 -- walther_denis@gmx.de

set -o pipefail

# Define the Python version to use for the virtual environment. Adjust this if you have a different version installed.
PYTHON_VERSION_NUMBER=$(python3 --version | cut -d ' ' -f2)
PYTHON_VERSION="python${PYTHON_VERSION_NUMBER%.*}"

function print_usage() {
    echo ''
    echo "Usage: $0 [OPTIONS]"
    echo ''
    echo 'Options:'
    echo '  -c, --create         Create the virtual environment and install the dependencies'
    echo '  -d, --destroy        Destroy the virtual environment'
    echo '  -r, --recreate       Destroy and recreate the virtual environment'
    echo '  -u, --update         Update the virtual environment and the dependencies'
    echo '  -ur, --update-roles  Update the Ansible roles defined in requirements.yml'
    echo '  -h, --help           Show this help message and exit'
    echo ''
    echo 'Example:'
    echo "  $0 --create"
    echo ''
    exit 1
}

function create_environment() {
    if [[ -d .venv ]]; then
        echo "Virtual environment already exists."
        exit 1
    else
        # Python3.11 is needed since Debian Bookworm does not offer a higher version
        "${PYTHON_VERSION}" -m venv .venv
        # shellcheck source=/dev/null
        source .venv/bin/activate
        pip install --upgrade pip
        pip install -r requirements.txt
    fi
}

function destroy_environment() {
    if [[ -d .venv ]]; then
        rm -rf .venv
        echo "Virtual environment destroyed."
    else
        echo "Virtual environment does not exist."
        exit 1
    fi
}

function update_environment() {
    if [[ ! -d .venv ]]; then
        echo "Virtual environment does not exist. Creating it first..."
        create_environment
        # shellcheck source=/dev/null
        source .venv/bin/activate
        pip install --upgrade pip
        pip install --upgrade -r requirements.txt
    else
        # shellcheck source=/dev/null
        source .venv/bin/activate
        pip install --upgrade pip
        pip install --upgrade -r requirements.txt
    fi
}

function update_roles() {
    if [[ ! -d .venv ]]; then
        echo "Virtual environment does not exist. Creating it first..."
        create_environment
        # shellcheck source=/dev/null
        source .venv/bin/activate
        ansible-galaxy install -r requirements.yml -p roles/ --force
    else
        # shellcheck source=/dev/null
        source .venv/bin/activate
        ansible-galaxy install -r requirements.yml -p roles/ --force
    fi
}

# Main entry point of the script, to parse the command line arguments and call the appropriate function.
case "$1" in
    -c|--create)
        create_environment
        ;;
    -d|--destroy)
        destroy_environment
        ;;
    -r|--recreate)
        destroy_environment
        create_environment
        ;;
    -u|--update)
        update_environment
        ;;
    -ur|--update-roles)
        update_roles
        ;;
    -h|--help)
        print_usage
        ;;
    *)
        print_usage
        ;;
esac
