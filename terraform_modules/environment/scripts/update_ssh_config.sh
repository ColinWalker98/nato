#!/bin/bash
# Assign passed arguments to variables
action="$1"
jumphost_ip="$2"
app_ip="$3"
db_ip="$4"
stage="$5"
name="$6"

# SSH Config templates
jumphost_entry=$(cat <<EOF
Host ${stage}-${name}-jumphost
  HostName ${jumphost_ip}
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
EOF
)

app_entry=$(cat <<EOF
Host ${stage}-${name}-app
  HostName ${app_ip}
  User ubuntu
  ProxyJump ${stage}-jumphost
  IdentityFile ~/.ssh/id_rsa
EOF
)

db_entry=$(cat <<EOF
Host ${stage}-${name}-db
  HostName ${db_ip}
  User ubuntu
  ProxyJump ${stage}-jumphost
  IdentityFile ~/.ssh/id_rsa
EOF
)

# Function to remove existing SSH config entry.
remove_ssh_config() {
    local ssh_config_file="${HOME}/.ssh/config"
    local existing_host="${1}"

    if [ -f "${ssh_config_file}" ]; then
        # Remove existing block for the host if it exists
        awk -v host="${existing_host}" '
            BEGIN { in_block = 0 }
            $1 == "Host" && $2 == host { in_block = 1; next }
            in_block && /^(\s*Host|\s*$)/ { in_block = 0 }
            !in_block { print }
        ' "${ssh_config_file}" > "${ssh_config_file}.tmp" && mv "${ssh_config_file}.tmp" "${ssh_config_file}"
        echo "Entry for ${existing_host} removed from ${ssh_config_file}"
    else
        echo "SSH config file not found"
    fi
}

# Function to append or replace exsiting SSH config entry.
append_or_replace_ssh_config() {
    local ssh_config_file="${HOME}/.ssh/config"
    local new_ssh_config="${1}"
    local existing_host="${2}"

    if [ -f "${ssh_config_file}" ]; then
        # Remove existing block for the host if it exists
        awk -v host="${existing_host}" '
            BEGIN { in_block = 0 }
            $2 == "Host" && $3 == host { in_block = 1; next }
            in_block && /^(\s*Host|\s*$)/ { in_block = 0 }
            !in_block { print }
        ' "${ssh_config_file}" > "${ssh_config_file}.tmp" && mv "${ssh_config_file}.tmp" "${ssh_config_file}"

        # Append new entry to the config file
        echo -e "${new_ssh_config}\n" >> "${ssh_config_file}"
        echo "Entry added to ${ssh_config_file}"
    else
        # Create new config file with the entry
        echo "${new_ssh_config}" > "${ssh_config_file}"
        chmod 600 "${ssh_config_file}"
        echo "New ${ssh_config_file} created with entry"
    fi
}

case "${action}" in
    "addition")
        append_or_replace_ssh_config "${jumphost_entry}" "${stage}-${name}-jumphost"
        append_or_replace_ssh_config "${app_entry}" "${stage}-${name}-app"
        append_or_replace_ssh_config "${db_entry}" "${stage}-${name}-db"
        ;;
    "removal")
        remove_ssh_config "${stage}-${name}-jumphost"
        remove_ssh_config "${stage}-${name}-app"
        remove_ssh_config "${stage}-${name}-db"
        ;;
esac
