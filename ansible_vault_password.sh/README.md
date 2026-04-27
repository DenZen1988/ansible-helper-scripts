# ansible_vault_password\.sh

This script can be used to fetch your password for `ansible-vault` encrypted files instead of a plaintext file or entering the password
manually everytime.

## Table Of Content

* [Setup the script](#setup-the-script)
  * [ansible.cfg](#ansiblecfg)
  * [Prerequisite Setup](#prerequisite-setup)
* [Use the script](#use-the-script)

## Setup the script

### ansible\.cfg

Simply adjust your `ansible.cfg` like this to use the script instead of a manually entered or plain text saved password:

```toml
vault_password_file = ./ansible-vault-password.sh
```

### Prerequisite Setup

The only prerequisites for the `ansible-password-script.sh` to work are:

* `VAULT_ADDR` as environment variable needs to be set
* login to the your hashicorp vault like this: `vault login...`

## Use the script

You can use the script manually, but that should only be done for debugging purposes. Be aware that you will leak the password onto your
commandline - so be careful!
