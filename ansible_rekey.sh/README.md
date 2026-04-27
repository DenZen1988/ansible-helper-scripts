# ansible_rekey\.sh

## Table Of Content

* [Options](#options)
  * [Rotate](#rotate)
  * [Rekey](#rekey)
  * [Cleanup](#cleanup)
* [Configuration Options](#configuration-options)
  * [VAULT_INSTANCE](#vault_instance)
  * [BACKEND_PATH](#backend_path)
  * [IAC_DIRECTORY](#iac_directory)
  * [(Optional) TMP](#optional-tmp)
* [Usage](#usage)

## Options

There a couple of options the script can be used with. It is also written to be used interactively since it can do some major harm to
our ansible repository.

### Rotate

The option `-r` stands for rotate and will do exactly that - rotate the password within the provided vault instance. Here is an example
done on the prelive vault:

```bash
$:> ansible_rekey.sh -r
Working on the prelive vault: https://prelive-vault.example.com
Vault password fetched and stored in /tmp/.current_vault_password.txt
New vault password generated and stored in /tmp/.new_vault_password.txt
OK: Vault passwords are different. You can now proceed with rekeying.
```

### Rekey

The option `-k` stands for rekeying the ansible vaulted files. It will jump into the provided `IaC/ansible` directory and check all files
for the ansible-vault header. If the file is vaulted the new password will be set.

Here is an example - it failed because for development the prelive vault is still set:

```bash
$:> ansible_rekey.sh -k
Working on the prelive vault: https://prelive-vault.example.com
Do you want to continue with rekeying the vault files with the new vault password? (y/n) y
Rekeyed secrets1.yml with the new vault password.
Rekeyed secrets2.yml with the new vault password.
Rekeyed secrets3.yml with the new vault password.
Rekeying completed.
```

### Cleanup

The option `-c` is used for cleanup purposes. You can run the rotation only the just rotate the password and then do the rekey. This is
designed that way because it can cause major harm. If anything fails, for example, there will not be any random passwords used for the vaulted
files.

```bash
$:> ansible_rekey.sh -c
Cleaned up vault password files: /tmp/.current_vault_password.txt and /tmp/.new_vault_password.txt
```

## Configuration Options

### VAULT_INSTANCE

Set the desired vault instance (prelive or live) in your `~/.ansible_rekey.conf` like this:

```bash
VAULT_INSTANCE='https://prelive-vault.example.com'
```

### BACKEND_PATH

Set the disired backend path on vault like this in your `~/.ansible_rekey.conf`:

```bash
BACKEND_PATH='path/to/secrets/ansible_vault'
```

### IAC_DIRECTORY

Setup the main ansible directory in your `~/.ansible_rekey.conf` like this:

```bash
IAC_DIRECTORY='/home/username/path/to/ansible'
```

### (Optional) TMP

Optionally you can also configure a specific temporary folder to store the password files. By default it will be `/tmp`:

```bash
TMP='/tmp'
```

## Usage

The usage is pretty straightforward. Simply run the script in this order:

1. Optional: `ansible_rekey.sh -c` - *does not hurt in case you still had some older password files*
2. `ansible_rekey.sh -r` - *rotate the password on the vault and create the needed temporary password files*
3. `ansible_rekey.sh -k` - *rekey the vaulted files in our ansible repository with the new password*
