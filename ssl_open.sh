#!/bin/bash

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

if [ -z "$BACKEND_URL" ]; then
    echo "Error: BACKEND_URL is not set."
    exit 1
fi

usage() {
    echo "Usage: $0 --username <username> --password <password> --open <true|false>"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --username) USERNAME="$2"; shift ;;
        --password) PASSWORD="$2"; shift ;;
        --open) OPEN="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

if [[ -z "$USERNAME" || -z "$PASSWORD" || -z "$OPEN" ]]; then
    echo "Error: Missing required arguments."
    usage
fi

if [[ "$OPEN" != "true" && "$OPEN" != "false" ]]; then
    echo "Error: --open must be 'true' or 'false'."
    usage
fi

AUTH_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/auth/local" -H "Content-Type: application/json" \
    -d "{\"identifier\": \"$USERNAME\", \"password\": \"$PASSWORD\"}")

JWT_TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.jwt')

if [[ "$JWT_TOKEN" == "null" || -z "$JWT_TOKEN" ]]; then
    echo "Error: Authentication failed."
    exit 1
fi

SSL_UPDATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$BACKEND_URL/api/is-ssl-open" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $JWT_TOKEN" \
    -d "{\"data\": {\"current_status\": $OPEN}}")

if [[ "$SSL_UPDATE_RESPONSE" -eq 200 ]]; then
    echo "Status updated successfully."
else
    echo "Error: Something went wrong. HTTP Status: $SSL_UPDATE_RESPONSE"
    exit 1
fi