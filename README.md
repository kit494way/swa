# SWA

Switch aws cli profile.

This script shows the profile names read from ~/.aws/config, and set the selected name to the envionment variable `AWS_PROFILE`.
`PS1` is also changed when a profile other than default is selected.

## Prerequisite

- bash
- gawk

## Install

Download script wherever you like.

```sh
$ curl https://raw.githubusercontent.com/kit494way/swa/master/swa.bash -o ~/swa.bash
```

Source the script in .bashrc.

```sh
$ echo 'source ${HOME}/swa.bash' >>~/.bashrc
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
