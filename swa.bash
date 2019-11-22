#!/usr/bin/env bash

swa() {
  local profile=$(_swa_select_profile)

  local basedir=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
  local params=($(gawk -f "${basedir}/extract-assume-role-params.awk" -v profile="${profile}" ~/.aws/config))

  if [[ "${#params[@]}" -eq 3 ]]; then
    _swa_assume_role "${profile}" ${params[@]}
  else
    _swa_switch_profile "${profile}"
  fi
}

_swa_switch_profile()
{
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  export AWS_PROFILE="${1}"

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

_swa_assume_role() {
  local profile="${1}"
  local role_arn="${2}"
  local source_profile="${3}"
  local mfa_serial="${4}"
  declare -A params
  if [[ -f "${HOME}/.swa/config" ]]; then
    eval "params=($(gawk -f ${basedir}/extract-swa-config.awk -v profile=${profile} ~/.swa/config))"
  fi

  if [[ -n "${_SWA_PS1_ORG}" ]]; then
    PS1="${_SWA_PS1_ORG}"
  fi

  unset _SWA_PS1_ORG
  unset AWS_PROFILE

  local code=""
  read -s -p "Enter MFA code for ${mfa_serial} " code

  local credentials=($(aws --profile "${source_profile}" sts assume-role \
    --role-arn "${role_arn}" \
    --role-session-name swa \
    --serial-number "${mfa_serial}" \
    --token-code "${code}" \
    --duration-seconds "${params[duration]:-3600}" \
    --output text --query 'Credentials | [AccessKeyId, SecretAccessKey, SessionToken] | join(`" "`, @)'))

  if [[ "${#credentials[@]}" -ne 3 ]]; then
    echo "Failed to assume role ${role_arn}." >&2
    return 1
  fi

  export AWS_ACCESS_KEY_ID="${credentials[0]}"
  export AWS_SECRET_ACCESS_KEY="${credentials[1]}"
  export AWS_SESSION_TOKEN="${credentials[2]}"

  _SWA_PS1_ORG="${PS1}"
  PS1="(${role_arn})${_SWA_PS1_ORG}"

  echo "AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN were exported."
}

_swa_select_profile() {
  local aws_profiles=$(gawk 'match($0,/\[(profile )?(.+)\]/,a){print a[2]}' ~/.aws/config)
  PS3="Select aws profile: "
  select profile in $aws_profiles; do
    echo $profile
    break
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script is intended to be sourced."
  exit 1
fi
