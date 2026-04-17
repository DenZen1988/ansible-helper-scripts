# setup\.sh

A unified script to manage your virtual environment in your ansible repository. It is meant to be used with ansible and might fail on
other setups.

## Table Of Content

* [Script Location](#script-location)
* [Usage](#usage)
  * [Create](#create)
  * [Destroy](#destroy)
  * [Recreate](#recreate)
  * [Update](#update)
  * [Update Roles](#update-roles)

## Script Location

The script should be located in your root folder of your ansible project. It will not work properly within a role or plugin! From there
it can read your `requirements.txt` and your `requirements.yml`. The provided examples are just for showcasing and testing.

## Usage

The usage is straight forward. Just call the script with the disired option:

```bash
Usage: ./setup.sh [OPTIONS]

Options:
  -c, --create         Create the virtual environment and install the dependencies
  -d, --destroy        Destroy the virtual environment
  -r, --recreate       Destroy and recreate the virtual environment
  -u, --update         Update the virtual environment and the dependencies
  -ur, --update-roles  Update the Ansible roles defined in requirements.yml
  -h, --help           Show this help message and exit

Example:
  ./setup.sh --create
```

### Create

The option `-c` or `--create` will create the virtual environment in the working directory:

```bash
$:> ./setup.sh -c
Requirement already satisfied: pip in ./.venv/lib/python3.14/site-packages (26.0.1)
Collecting ansible==12.3.0 (from -r requirements.txt (line 2))
  Using cached ansible-12.3.0-py3-none-any.whl.metadata (8.1 kB)
[...]
Successfully installed Jinja2-3.1.6 MarkupSafe-3.0.3 PyYAML-6.0.3 ansible-12.3.0 ansible-compat-25.12.0 ansible-core-2.19.7 ansible-lint-26.1.1 argcomplete-3.6.3 attrs-25.4.0 black-26.1.0 bracex-2.6 certifi-2026.2.25 cffi-2.0.0 charset_normalizer-3.4.7 click-8.3.1 click-help-colors-0.9.4 cryptography-46.0.5 distro-1.9.0 docker-7.1.0 enrich-1.2.7 filelock-3.24.2 idna-3.11 jsonschema-4.26.0 jsonschema-specifications-2025.9.1 markdown-it-py-4.0.0 mdurl-0.1.2 molecule-24.12.0 molecule-plugins-23.5.3 mypy_extensions-1.1.0 packaging-26.0 pathspec-1.0.4 platformdirs-4.9.2 pluggy-1.6.0 pycparser-3.0 pygments-2.20.0 pytokens-0.4.1 referencing-0.37.0 requests-2.33.1 resolvelib-1.2.1 rich-15.0.0 rpds-py-0.30.0 ruamel.yaml-0.19.1 subprocess-tee-0.4.2 urllib3-2.6.3 wcmatch-10.1 yamllint-1.38.0
```

### Destroy

The option `-d` or `--destroy` will destroy/remove the virtual environment in the working directory:

```bash
$:> ./setup.sh -d
Virtual environment destroyed.
```

### Recreate

The option `-r` or `--recreate` will destroy/remove the virtual environment and create it, again in the working directory:

```bash
$:> ./setup.sh -r
Virtual environment destroyed.
Requirement already satisfied: pip in ./.venv/lib/python3.14/site-packages (26.0.1)
Collecting ansible==12.3.0 (from -r requirements.txt (line 2))
  Using cached ansible-12.3.0-py3-none-any.whl.metadata (8.1 kB)
[...]
Successfully installed Jinja2-3.1.6 MarkupSafe-3.0.3 PyYAML-6.0.3 ansible-12.3.0 ansible-compat-25.12.0 ansible-core-2.19.7 ansible-lint-26.1.1 argcomplete-3.6.3 attrs-25.4.0 black-26.1.0 bracex-2.6 certifi-2026.2.25 cffi-2.0.0 charset_normalizer-3.4.7 click-8.3.1 click-help-colors-0.9.4 cryptography-46.0.5 distro-1.9.0 docker-7.1.0 enrich-1.2.7 filelock-3.24.2 idna-3.11 jsonschema-4.26.0 jsonschema-specifications-2025.9.1 markdown-it-py-4.0.0 mdurl-0.1.2 molecule-24.12.0 molecule-plugins-23.5.3 mypy_extensions-1.1.0 packaging-26.0 pathspec-1.0.4 platformdirs-4.9.2 pluggy-1.6.0 pycparser-3.0 pygments-2.20.0 pytokens-0.4.1 referencing-0.37.0 requests-2.33.1 resolvelib-1.2.1 rich-15.0.0 rpds-py-0.30.0 ruamel.yaml-0.19.1 subprocess-tee-0.4.2 urllib3-2.6.3 wcmatch-10.1 yamllint-1.38.0
```

### Update

The option `-u` or `--update` will update the virtual environment if there is a new version of pip or you changed versions in requirements.txt.
If there is nothing to update the output will look like this:

```bash
$:> ./setup.sh -u
Requirement already satisfied: pip in ./.venv/lib/python3.14/site-packages (26.0.1)
[...]
Requirement already satisfied: mdurl~=0.1 in ./.venv/lib/python3.14/site-packages (from markdown-it-py>=2.2.0->rich>=9.5.1->molecule==24.12.0->-r requirements.txt (line 33)) (0.1.2)
```

### Update Roles

The option `-ur` or `--update-roles` will update your roles which are mentioned in the requirements.yml:

```bash
$:> ./setup.sh -ur
Starting galaxy role install process
- extracting ansible-nginx to /Users/dwalter/Work/Repos/Private/GitHub/Ansible/ansible-helper-scripts/setup.sh/roles/ansible-nginx
- ansible-nginx (v11.13.1) was installed successfully
```
