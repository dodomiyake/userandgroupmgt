# User and Group Management Bash Script

Welcome to the User and Group Management Bash Script! This script is designed to help you automate the process of creating users and assigning them to groups on a Linux system, all based on a simple input file.

## Overview

Managing users and groups can be a tedious task, especially when dealing with multiple accounts. This script simplifies the process by reading from a text file and performing all the necessary operations, including logging actions and generating secure passwords for new users.

## Getting Started

Follow these steps to get up and running with the script:

### Prerequisites

- You need to have root privileges to run this script. This is because creating users and groups requires administrative access.

### Usage

1. **Save the Script**

   Save the provided script to a file, for example, `create_users.sh`.

2. **Prepare Your Input File**

   Create an input file (e.g., `input.txt`) with the following format:

   ```
   username;group1,group2,group3
   ```

   Each line should represent one user and their respective groups.

3. **Run the Script**

   Now, run the script with your input file:

   ```bash
   sudo ./create_users.sh input.txt
   ```

## How the Script Works

Here's a breakdown of what the script does:

1. **Shebang and Comments**

   The script starts with the shebang (`#!/bin/bash`) to specify the Bash shell. Comments explain what the script does and the expected format of the input file.

2. **Setting Up Log and Password Files**

   The script defines where to store logs and generated passwords:

   ```bash
   LOG_FILE=/var/log/user_management.log
   PASSWORD_FILE=/var/secure/user_passwords.txt
   ```

   These files help keep track of actions and ensure you have a record of the generated passwords.

3. **Checking for Root Privileges**

   The script checks if it's being run as root:

   ```bash
   if [ $(id -u) -ne 0 ]; then
       echo "You must run this script as the root user. Try using 'sudo'!"
       exit 1
   fi
   ```

4. **Verifying the Input File**

   It verifies that an input file is provided and assigns it to a variable:

   ```bash
   if [ $# -ne 1 ]; then
       echo "You need to provide an input file!"
       echo "Usage: $0 <input_file>"
       exit 1
   fi

   INPUT_FILE=$1
   ```

5. **Preparing Log and Password Files**

   The script ensures the log and password files exist and sets their permissions:

   ```bash
   touch $LOG_FILE
   chmod 600 $LOG_FILE
   touch $PASSWORD_FILE
   chmod 600 $PASSWORD_FILE
   ```

6. **Processing Each Line of the Input File**

   It reads each line, splits it into the username and groups, and performs the necessary actions:

   ```bash
   while IFS= read -r line; do
       username=$(echo "$line" | cut -d';' -f1)
       groups=$(echo "$line" | cut -d';' -f2-)
   ```

7. **Creating User's Personal Group**

   The script creates a personal group for each user if it doesn't already exist:

   ```bash
       group_name=$username
       if ! grep -q "^$group_name:" /etc/group; then
           groupadd $group_name
           echo "Created group $group_name" >>$LOG_FILE
       fi
   ```

8. **Creating the User**

   It checks if the user exists and creates them if they don't:

   ```bash
       if ! id $username >/dev/null; then
           useradd -m -g $group_name -s /bin/bash $username
           echo "Created user $username" >>$LOG_FILE
       else
           echo "User $username already exists" >>$LOG_FILE
       fi
   ```

9. **Adding User to Specified Groups**

   The script adds the user to specified groups, creating the groups if necessary:

   ```bash
       for group in $(echo $groups | tr ',' ' '); do
           if ! grep -q "^$group:" /etc/group; then
               groupadd $group
               echo "Created group $group" >>$LOG_FILE
           fi
           usermod -aG $group $username
           echo "Added user $username to group $group" >>$LOG_FILE
       done
   ```

10. **Generating and Setting User Passwords**

    It generates a random password for each user, logs it, and sets the password:

    ```bash
       password=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
       echo "$username:$password" >>"$PASSWORD_FILE"
       echo "Generated password for user $username" >>"$LOG_FILE"

       echo "$username:$password" | chpasswd
       echo "Set password for user $username" >>"$LOG_FILE"
   done <"$INPUT_FILE"
   ```

## Conclusion

This Bash script is a handy tool for automating the creation of users and groups on a Linux system. By understanding and using this script, you can save time and reduce errors in managing users.

[HNG Internship](https://hng.tech/internship)