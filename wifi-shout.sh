#!/usr/bin/env sh

version="0.1.0"

airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

if [ ! -f $airport ]; then
  echo "Error: \`airport\` not  found at \"$airport\""
  exit 1
fi

usage() {
  cat <<EOF
  Usage: wifi-shout [options]
  Options:
    -v, --version    Shout version
    -h, --help       Shout help
    --               Bleh
EOF
}

#while [] do
  case $1 in
    -v | --version)
      echo $version
      exit
      ;;
    -h | --help)
      usage
      exit
      ;;
  esac
  shift
#done

if [ "$1" == "--" ]
  then shift;
fi

ssid="`$airport -I | awk '/ SSID/ {print $2}'`"
if [ "$ssid" = "" ]; then
  echo "ERROR: Could not retrieve current SSID. Are you connected?" >&2
  exit 1
fi

sleep 2

password="`security find-generic-password -D 'AirPort network password' -ga \"$ssid\" 2>&1 >/dev/null`"

password=$(echo "$password" | sed -e "s/^.*\"\(.*\)\".*$/\1/")
echo "\033[96m ✓ \"$password\" \033[39m"
