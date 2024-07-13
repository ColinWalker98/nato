#!/bin/bash
# Assign passed arguments to variables
jumphost_ip="$1"
app_ip="$2"
db_ip="$3"
stage="$4"

# SSH Config templates
jumphost_entry=$(cat <<EOF
Host ${stage}-jumphost
  HostName ${jumphost_ip}
  User ubuntu
  IdentityFile ~/.ssh/id_rsa
EOF
)

app_entry=$(cat <<EOF
Host ${stage}-app
  HostName ${app_ip}
  User ubuntu
  ProxyJump ${stage}-jumphost
  IdentityFile ~/.ssh/id_rsa
EOF
)

db_entry=$(cat <<EOF
Host ${stage}-db
  HostName ${db_ip}
  User ubuntu
  ProxyJump ${stage}-jumphost
  IdentityFile ~/.ssh/id_rsa
EOF
)


# Function to append or replace exsiting SSH config entry.
append_or_replace_ssh_config() {
    local ssh_config_file="${HOME}/.ssh/config"
    local new_ssh_config="${1}"
    local existing_host="${2}"

    if [ -f "${ssh_config_file}" ]; then
        # Remove existing block for the host if it exists
        awk -v host="${existing_host}" '
            BEGIN { in_block = 0 }
            $1 == "Host" && $2 == host { in_block = 1; next }
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

# Call function for each entry
append_or_replace_ssh_config "${jumphost_entry}" "${stage}-jumphost"
append_or_replace_ssh_config "${app_entry}" "${stage}-app"
append_or_replace_ssh_config "${db_entry}" "${stage}-db"
