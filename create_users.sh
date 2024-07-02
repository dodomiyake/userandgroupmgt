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

