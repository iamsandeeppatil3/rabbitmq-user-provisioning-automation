#!/bin/bash

###############################################################################
# Script Name : send_credentials_email.sh
# Author      : Sandeep Patil
# Version     : 1.0
# Created     : 2025-11-01
# Updated     : 2026-06-08
#
# Purpose:
# Reads RabbitMQ credentials from an exported file and sends
# onboarding emails to users containing their account details.
#
# Features:
# - Bulk email distribution
# - Credential file processing
# - Customizable sender address
# - Customizable RabbitMQ endpoint information
#
# Requirements:
# - mailutils (or compatible mail command)
# - Valid SMTP configuration
#
# Usage:
# ./send_credentials_email.sh
#
###############################################################################

set -o errexit
set -o nounset
set -o pipefail

###############################################################################

# Configuration

###############################################################################

CREDENTIAL_FILE="./rabbitmq-user-credentials.txt"

SENDER_EMAIL="[noreply@example.com](mailto:noreply@example.com)"

RABBITMQ_NAME="RabbitMQ Cluster"
RABBITMQ_ENDPOINT="rabbitmq.example.com"

###############################################################################

# Validation

###############################################################################

if [[ ! -f "$CREDENTIAL_FILE" ]]
then
echo "Credential file not found: $CREDENTIAL_FILE"
exit 1
fi

if ! command -v mail >/dev/null 2>&1
then
echo "'mail' command not found."
exit 1
fi

###############################################################################

# Send Emails

###############################################################################

while read -r username password email
do
[[ -z "$username" ]] && continue

```
echo "Sending credentials to ${email}..."

mail_body=$(cat <<EOF
```

Hello,

Your RabbitMQ account has been provisioned.

## Connection Details

RabbitMQ Instance : ${RABBITMQ_NAME}
Endpoint          : ${RABBITMQ_ENDPOINT}

## Credentials

Username : ${username}
Password : ${password}

Please store these credentials securely.

Regards,
Infrastructure Team
EOF
)

```
echo "$mail_body" | mail \
    -s "RabbitMQ Access Credentials" \
    -r "$SENDER_EMAIL" \
    "$email"
```

done < "$CREDENTIAL_FILE"

echo
echo "Credential distribution completed."
