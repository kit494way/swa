# SWA

Switch aws cli profile.

This script set the selected profile name to the envionment variable `AWS_PROFILE` or export variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN`.

## Prerequisite

- bash
- gawk

## Install

Clone this repository.

```sh
$ cd ${HOME}
$ git clone https://github.com/kit494way/swa.git
```

Source the script in .bashrc.

```sh
$ echo 'source ${HOME}/swa/swa.bash' >>~/.bashrc
```

**The script swa.bash is intended to be sourced.**
Executing the script does not work.

## Usage

```sh
$ swa
```

This shows list of profile name like this.

```sh
1) default
2) another
Select aws profile:
```

Enter the number preceding the profile you want to switch.

If selected profile is configured for switch role, execute `aws sts assume-role` and export `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` variables.
When switched that profile, MFA token is required.
