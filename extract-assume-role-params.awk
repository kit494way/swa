# `profile` variable is required.
# (e.g. gawk this-script.awk -v profile=<profile-name> ~/.aws/config)

BEGIN {
  section = "";
  role_arn = "";
  source_profile = "";
  mfa_serial = "";
}

match($0,/\[(profile )?(.+)\]/,a) {
  section = a[2]
}

section == profile && /role_arn/ {
  role_arn = $3
}

section == profile && /source_profile/ {
  source_profile = $3
}

section == profile && /mfa_serial/ {
  mfa_serial = $3
}

END {
  print role_arn, source_profile, mfa_serial
}
