BEGIN {
  section = ""
  duration = ""
}

match($0,/\[(.+)\]/,a) {
  section = a[1]
}

section == profile && /duration/ {
  duration = $3
}

END {
  print "[duration]="duration
}
