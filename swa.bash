#!/bin/bash

swa()
{
  aws_profiles=$(gawk 'match($0,/\[(profile )?(.+)\]/,a){print a[2]}' ~/.aws/config)
  PS3="Select aws profile: "
  select profile in $aws_profiles; do
    AWS_PROFILE=$profile
    break
  done

  export AWS_PROFILE

  if [[ -z "${_SWA_PS1_ORG}" ]]; then
    _SWA_PS1_ORG="${PS1}"
  fi

  if [[ "${AWS_PROFILE}" = "default" || -z "${AWS_PROFILE}" ]]; then
    PS1="${_SWA_PS1_ORG}"
    unset _SWA_PS1_ORG
    unset AWS_PROFILE
  else
    PS1="(aws:$AWS_PROFILE)${_SWA_PS1_ORG}"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script is intended to be sourced."
  exit 1
fi
