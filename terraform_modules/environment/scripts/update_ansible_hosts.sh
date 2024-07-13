#!/bin/bash
hostnames=("${1}-jumphost" "${1}-app" "${1}-db")
hosts_file="../../ansible/inventory/${1}/hosts.ini"

for hostname in "${hostnames[@]}"; do
  # Check if the hostname already exists in the hosts file
  if grep -q "^$hostname$" "$hosts_file"; then
      echo "Hostname $hostname already exists in $hosts_file."
  else
      # Add the hostname to the end of the hosts file
      echo "$hostname" >> "$hosts_file"
      echo "Hostname $hostname added to $hosts_file."
  fi
done