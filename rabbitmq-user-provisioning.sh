#!/bin/bash

###############################################################################
# Script Name : rabbitmq_user_provisioning.sh
# Author      : Sandeep Patil
# Version     : 1.0
# Created     : 2025-08-07
# Updated     : 2026-06-08
#
# Purpose:
#   Automates RabbitMQ user provisioning by creating accounts,
#   generating secure passwords, assigning user tags, applying
#   permissions across all virtual hosts, and exporting
#   credentials for onboarding workflows.
#
# Features:
#   - Bulk user creation from a file
#   - Automatic password generation
#   - RabbitMQ tag assignment
#   - Virtual host permission management
#   - Credential export for onboarding workflows
#
# Requirements:
#   - RabbitMQ Server
#   - rabbitmqctl
#   - pwgen
#
# Usage:
#   1. Populate users.txt with one username per line.
#   2. Update EMAIL_DOMAIN if required.
#   3. Execute the script.
#
###############################################################################

set -o errexit
set -o nounset
set -o pipefail

###############################################################################
# Configuration
###############################################################################

USER_FILE="./users.txt"
OUTPUT_FILE="./rabbitmq-user-credentials.txt"
EMAIL_DOMAIN="example.com"
USER_TAG="monitoring"

###############################################################################
# Dependency Check
###############################################################################

if ! command -v pwgen >/dev/null 2>&1
then
    echo "pwgen not found. Installing..."

    sudo apt-get update
    sudo apt-get install -y pwgen
fi

if ! command -v rabbitmqctl >/dev/null 2>&1
then
    echo "rabbitmqctl not found."
    exit 1
fi

###############################################################################
# Input Validation
###############################################################################

if [[ ! -f "$USER_FILE" ]]
then
    echo "User file not found: $USER_FILE"
    exit 1
fi

###############################################################################
# Retrieve RabbitMQ Virtual Hosts
###############################################################################

echo "Retrieving RabbitMQ virtual hosts..."

mapfile -t VHOSTS < <(
    sudo rabbitmqctl list_vhosts --quiet 2>/dev/null
)

###############################################################################
# Prepare Output File
###############################################################################

: > "$OUTPUT_FILE"

###############################################################################
# Create Users
###############################################################################

echo "Starting RabbitMQ user provisioning..."

while read -r user
do
    [[ -z "$user" ]] && continue

    password=$(pwgen -nsv 15 1)

    echo "Creating user: $user"

    sudo rabbitmqctl add_user "$user" "$password"

    sudo rabbitmqctl set_user_tags "$user" "$USER_TAG"

    for vhost in "${VHOSTS[@]}"
    do
        sudo rabbitmqctl set_permissions \
            -p "$vhost" \
            "$user" \
            "^$" \
            "^$" \
            "^$"
    done

    echo "${user} ${password} ${user}@${EMAIL_DOMAIN}" \
        >> "$OUTPUT_FILE"

done < "$USER_FILE"

###############################################################################
# Summary
###############################################################################

echo
echo "Provisioning completed."
echo "Credentials exported to:"
echo "  $OUTPUT_FILE"
echo
echo "Review credentials before distribution."
