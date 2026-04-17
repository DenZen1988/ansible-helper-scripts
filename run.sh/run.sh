#!/usr/bin/env bash

# Script to trigger the different ansible binaries from the virtual environment
# 2026-04-17 -- walther_denis@gmx.de

set -o pipefail

# Available Binaries in .venv/bin/
#
# ansible
# ansible-community
# ansible-config
# ansible-console
# ansible-doc
# ansible-galaxy
# ansible-inventory
# ansible-lint
# ansible-playbook
# ansible-pull
# ansible-test
# ansible-vault
# molecule

# FUNCTIONS
# Print the usage of the script
function print_usage() {
    echo ''
    echo "Usage: $0 [OPTIONS] [ANSIBLE_ARGS]"
    echo ''
    echo 'Options:'
    echo '  -a, ansible        Run ansible with the given arguments'
    echo '  -p, playbook       Run ansible-playbook with the given arguments'
    echo '  -c, console        Run ansible-console with the given arguments'
    echo '  -d, doc            Run ansible-doc with the given arguments'
    echo '  -g, galaxy         Run ansible-galaxy with the given arguments'
    echo '  -i, inventory      Run ansible-inventory with the given arguments'
    echo '  -l, lint           Run ansible-lint with the given arguments'
    echo '  -m, molecule       Run molecule with the given arguments'
    echo '  -p, pull           Run ansible-pull with the given arguments'
    echo '  -t, test           Run ansible-test with the given arguments'
    echo '  -v, vault          Run ansible-vault with the given arguments'
    echo '  -h, help           Show this help message and exit'
    echo ''
    echo 'Example:'
    echo "  $0 playbook playbooks/site.yml --tags=base --limit="defansibleclientqa00*" --check"
    echo ''
}
# Fail if the virtual environment does not exist
function check_venv() {
    if [[ ! -d .venv ]]; then
        echo "Virtual environment does not exist. Please run setup.sh to create it first."
        exit 1
    fi
}
# MAIN
case "$1" in
    -a|ansible)
        check_venv
        .venv/bin/ansible "${@:2}"
        ;;
    -p|playbook)
        check_venv
        .venv/bin/ansible-playbook "${@:2}"
        ;;
    -c|console)
        check_venv
        .venv/bin/ansible-console "${@:2}"
        ;;
    -d|doc)
        check_venv
        .venv/bin/ansible-doc "${@:2}"
        ;;
    -g|galaxy)
        check_venv
        .venv/bin/ansible-galaxy "${@:2}"
        ;;
    -i|inventory)
        check_venv
        .venv/bin/ansible-inventory "${@:2}"
        ;;
    -l|lint)
        check_venv
        .venv/bin/ansible-lint "${@:2}"
        ;;
    -m|molecule)
        check_venv
        .venv/bin/molecule "${@:2}"
        ;;
    -pu|pull)
        check_venv
        .venv/bin/ansible-pull "${@:2}"
        ;;
    -t|test)
        check_venv
        .venv/bin/ansible-test "${@:2}"
        ;;
    -v|vault)
        check_venv
        .venv/bin/ansible-vault "${@:2}"
        ;;
    *)
        print_usage
        ;;
esac
