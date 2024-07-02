#!/bin/bash

# This script creates users and groups from a text file
# The text file should have the format: username;group1,group2,group3

# Set the log file and password file
LOG_FILE=/var/log/user_management.log
PASSWORD_FILE=/var/secure/user_passwords.txt