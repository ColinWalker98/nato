#!/bin/bash
action="$1"
hostnames=("${2}-${3}-jumphost" "${2}-${3}-app" "${2}-${3}-db")
hosts_file="../../ansible/inventory/${2}/hosts.ini"

case "${action}" in
  "addition")
    for hostname in "${hostnames[@]}"; do
      # Check if the hostname already exists in the hosts file.
      if grep -q "^$hostname$" "$hosts_file"; then
          echo "Hostname $hostname already exists in $hosts_file."
      else
          # Add the hostname to the end of the hosts file.
          echo "$hostname" >> "$hosts_file"
          echo "Hostname $hostname added to $hosts_file."
      fi
    done
    ;;
  "removal")
    for hostname in "${hostnames[@]}"; do
      # Check if the hostname exists in the hosts file.
      if grep -q "^$hostname$" "$hosts_file"; then
          # Remove the hostname from the hosts file.
          sed -i "/^$hostname$/d" "$hosts_file"
          echo "Hostname $hostname removed from $hosts_file."
      else
          echo "Hostname $hostname does not exist in $hosts_file."
      fi
    done
    ;;
esac