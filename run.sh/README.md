# run\.sh

A script to call the binaries from your virtual environment. This script is meant to be used with ansible (and molecule) and will fail
if you try to use it for other binaries.

## Table Of Content

* [Script Location](#script-location)
* [Usage](#usage)
  * [ansible](#ansible)
  * [playbook](#playbook)
  * [console](#console)
  * [doc](#doc)
  * [galaxy](#galaxy)
  * [inventory](#inventory)
  * [lint](#lint)
  * [molecule](#molecule)
  * [pull](#pull)
  * [test](#test)
  * [vault](#vault)

## Script Location

The script should be located in your root folder of your ansible project. It will not work properly within a role or plugin! The provided
examples are just for showcasing and testing.

## Usage

The usage is straight forward. Just call the script with the disired options:

```bash
Usage: ./run.sh [OPTIONS] [ANSIBLE_ARGS]

Options:
  -a, ansible        Run ansible with the given arguments
  -p, playbook       Run ansible-playbook with the given arguments
  -c, console        Run ansible-console with the given arguments
  -d, doc            Run ansible-doc with the given arguments
  -g, galaxy         Run ansible-galaxy with the given arguments
  -i, inventory      Run ansible-inventory with the given arguments
  -l, lint           Run ansible-lint with the given arguments
  -m, molecule       Run molecule with the given arguments
  -p, pull           Run ansible-pull with the given arguments
  -t, test           Run ansible-test with the given arguments
  -v, vault          Run ansible-vault with the given arguments
  -h, help           Show this help message and exit

Example:
  ./run.sh playbook playbooks/site.yml --tags=base --limit="example.webservers00*" --check
```

### Ansible

The option `-a` or `ansible` calls the binary `.venv/bin/ansible`:

```bash
$:> ./run.sh -a --version
ansible [core 2.19.7]
  config file = /path/to/ansible.cfg
  configured module search path = ['/path/to/plugins/modules']
  ansible python module location = /path/to/.venv/lib/python3.11/site-packages/ansible
  ansible collection location = /path/to/collections
  executable location = .venv/bin/ansible
  python version = 3.11.15 (main, Mar  7 2026, 04:57:07) [Clang 17.0.0 (clang-1700.6.3.2)] (/path/to/.venv/bin/python3.11)
  jinja version = 3.1.6
  pyyaml version = 6.0.3 (with libyaml v0.2.5)
```

### Playbook

The option `-p` or `playbook` calls the binary `.venv/bin/ansible-playbook`:

```bash
$:> ./run.sh -p playbooks/site.yml --tags=telegraf --limit="example.com" --check

PLAY [Deploy Custom Facts] ************************************************************************************************

PLAY [Deploy One Role] ****************************************************************************************************

PLAY [Deploy A 2nd Role] **************************************************************************************************

PLAY [Deploy Another Role] ************************************************************************************************

PLAY [Deploy Telegraf] ****************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************
ok: [example.com]

TASK [telegraf : Add Influxdata Repository] *******************************************************************************
ok: [example.com]

TASK [telegraf : Install Telegraf] ****************************************************************************************
ok: [example.com]

TASK [telegraf : Place configuration file] ********************************************************************************
ok: [example.com]

TASK [telegraf : Ensure telegraf is enabled and running] ******************************************************************
ok: [example.com]

PLAY RECAP ****************************************************************************************************************
example.com : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

### Console

The option `-c` or `console` calls the binary `.venv/bin/ansible-console`:

```bash
$:> ./run.sh -c
Welcome to the ansible console. Type help or ? to list commands.

user@all (680)[f:5]$ 
```

### Doc

The option `-d` or `doc` calls the binary `.venv/bin/ansible-doc`:

```bash
$:> ./run.sh -d ansible.builtin.apt
> MODULE ansible.builtin.apt (/path/to/.venv/lib/python3.11/site-packages/ansible/modules/apt.py)

  Manages apt packages (such as for Debian/Ubuntu).

OPTIONS (red indicates it is required):

   allow_change_held_packages  Allows changing the version of a package which is on the apt hold list.
        default: 'no'
        type: bool

   allow_downgrade  Corresponds to the `--allow-downgrades' option for apt.
                    This option enables the named package and version to replace an already installed higher version of that package.
                    Note that setting `allow_downgrade=true' can make this module behave in a non-idempotent way.
                    (The task could end up with a set of packages that does not match the complete list of specified packages to install).
                    `allow_downgrade' is only supported by `apt' and will be ignored if `aptitude' is detected or specified.
        aliases: [allow-downgrade, allow_downgrades, allow-downgrades]
        default: 'no'
        type: bool

   allow_unauthenticated  Ignore if packages cannot be authenticated. This is useful for bootstrapping environments that manage their own apt-key setup.
                          `allow_unauthenticated' is only supported with `state': `install'/`present'.
        aliases: [allow-unauthenticated]
        default: 'no'
        type: bool

   auto_install_module_deps  Automatically install dependencies required to run this module.
        default: true
        type: bool

   autoclean  If `true', cleans the local repository of retrieved package files that can no longer be downloaded.
        default: 'no'
        type: bool

   autoremove  If `true', remove unused dependency packages for all module states except `build-dep'. It can also be used as the only option.
               Previous to version 2.4, `autoclean' was also an alias for `autoremove', now it is its own separate command. See documentation for further information.
        default: 'no'
        type: bool
    [...]
```

### Galaxy

The option `-g` or `galaxy` calls the binary `.venv/bin/ansible-galaxy`:

```bash
$:> ./run.sh galaxy collection list

# /path/to/.venv/lib/python3.11/site-packages/ansible/_internal/ansible_collections
Collection                               Version
---------------------------------------- -------
ansible._protomatter                     2.19.7 

# /path/to/.venv/lib/python3.11/site-packages/ansible_collections
Collection                               Version
---------------------------------------- -------
amazon.aws                               10.1.2 
ansible.netcommon                        8.2.0  
ansible.posix                            2.1.0  
ansible.utils                            6.0.0  
ansible.windows                          3.3.0  
arista.eos                               12.0.0 
awx.awx                                  24.6.1 
azure.azcollection                       3.12.0 
check_point.mgmt                         6.7.0  
chocolatey.chocolatey                    1.5.3  
cisco.aci                                2.13.0 
cisco.dnac                               6.43.0 
cisco.intersight                         2.12.0 
cisco.ios                                11.1.1 
cisco.iosxr                              12.1.0 
cisco.meraki                             2.21.9 
[...]
```

### Inventory

The option `-i` or `inventory` calls the binary `.venv/bin/ansible-inventory`:

```bash
$:> ./run.sh inventory --list

{
    "_meta": {
        "hostvars": {
            "example.com": {
                "ansible_hashi_vault_addr": "https://vault.example.com",
                "ansible_hashi_vault_auth_method": "approle",
                "ansible_hashi_vault_engine_mount_point": "ansible",
                "ansible_hashi_vault_role_id": "Some-ID-Hash",
                "ansible_hashi_vault_secret_id": "Another-ID-Hash",
                "ansible_host": "example.com",
                "ansible_ports": [
                    24
                ],
            [...]
```

### Lint

The option `-l` or `lint` calls the binary `.venv/bin/ansible-lint`:

```bash
$:> ./run.sh lint .

Passed: 0 failure(s), 0 warning(s) in 2 files processed of 4 encountered. Last profile that met the validation criteria was 'production'.
```

### Molecule

The option `-m` or `molecule` calls the binary `.venv/bin/molecule`:

```bash
$:> ./run.sh molecule drivers
docker
azure
containers
gce
ec2
openstack
podman
vagrant
default
```

### Pull

The option `-p` or `pull` calls the binary `.venv/bin/ansible-pull`:

```bash
$:> ./run.sh pull -h
usage: ansible-pull [-h] [--version] [-v] [--private-key PRIVATE_KEY_FILE] [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT]
                    [--ssh-common-args SSH_COMMON_ARGS] [--sftp-extra-args SFTP_EXTRA_ARGS] [--scp-extra-args SCP_EXTRA_ARGS]
                    [--ssh-extra-args SSH_EXTRA_ARGS] [-k | --connection-password-file CONNECTION_PASSWORD_FILE] [--vault-id VAULT_IDS]
                    [-J | --vault-password-file VAULT_PASSWORD_FILES] [-e EXTRA_VARS] [-t TAGS] [--skip-tags SKIP_TAGS] [-i INVENTORY] [--list-hosts]
                    [-l SUBSET] [--flush-cache] [-M MODULE_PATH] [-K | --become-password-file BECOME_PASSWORD_FILE] [--purge] [-o] [-s SLEEP] [-f]
                    [-d DEST] [-U URL] [--full] [-C CHECKOUT] [--accept-host-key] [-m MODULE_NAME] [--verify-commit] [--clean] [--track-subs]
                    [--check] [--diff]
                    [playbook.yml ...]

pulls playbooks from a VCS repo and executes them on target host
[...]
```

### Test

The option `-t` or `test` calls the binary `.venv/bin/ansible-test`:

```bash
$:> ./run.sh test -h
usage: ansible-test [-h] [--version] COMMAND ...

positional arguments:
  COMMAND
    coverage           code coverage management and reporting
    env                show information about the test environment
    shell              open an interactive shell
    integration        posix integration tests
    network-integration
                       network integration tests
    windows-integration
                       windows integration tests
    sanity             sanity tests
    units              unit tests

options:
  -h, --help           show this help message and exit
  --version            show program's version number and exit

[...]
```

### Vault

The option `-v` or `vault` calls the binary `.venv/bin/ansible-vault`:

```bash
$:> ./run.sh vault view foobar.yml
---
my_variable: 'my_value'
```
