#!/bin/bash

# This script creates users and groups from a text file
# The text file should have the format: username;group1,group2,group3

# Set the log file and password file
LOG_FILE=/var/log/user_management.log
PASSWORD_FILE=/var/secure/user_passwords.txt

# Check if script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "You must run this script as the root user. Try using 'sudo'!"
    exit 1
fi

# Check if the input file is provided
if [ $# -ne 1 ]; then
    echo "You need to provide an input file!"
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Read the input file
INPUT_FILE=$1

# Create the log file and password file if they don't exist
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"
touch "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"

# Iterate over each line in the input file
while IFS=';' read -r username group_list || [ -n "$username" ]; do
    # Remove leading/trailing whitespace from username and groups
    username=$(echo "$username" | tr -d '[:space:]')
    group_list=$(echo "$group_list" | tr -d '[:space:]')

    # Create the user's personal group if it doesn't exist
    if ! grep -q "^$username:" /etc/group; then
        groupadd "$username"
        echo "Created group $username" >> "$LOG_FILE"
    fi

    # Create the user if they don't exist
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m -g "$username" -s /bin/bash "$username"
        echo "Created user $username" >> "$LOG_FILE"
    else
        echo "User $username already exists" >> "$LOG_FILE"
    fi

    # Add the user to the specified groups
    IFS=',' read -r -a groups <<< "$group_list"
    for group in "${groups[@]}"; do
        if ! grep -q "^$group:" /etc/group; then
            groupadd "$group"
            echo "Created group $group" >> "$LOG_FILE"
        fi
        usermod -aG "$group" "$username"
        echo "Added user $username to group $group" >> "$LOG_FILE"
    done

    # Generate a random password for the user
    password=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    echo "$username:$password" >> "$PASSWORD_FILE"
    echo "Generated password for user $username" >> "$LOG_FILE"

    # Set the password for the user
    echo "$username:$password" | chpasswd
    echo "Set password for user $username" >> "$LOG_FILE"
done < "$INPUT_FILE"