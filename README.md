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