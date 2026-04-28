#!/bin/bash
if [ -z "$1" ]; then
    echo "No input URL or IP was provided. Please provide a URL or IP address as an argument."
    exit 1
fi

if ! command -v dig > /dev/null 2>&1; then
    echo "The 'dig' command is not installed. Please install 'dig' to use this script."
    exit 1
fi

dns_check_output=$(dig +short $1)

if [ -z "$dns_check_output" ]; then
    echo "The provided input is not a valid URL or IP address. DNS resolution cannot resolve the input. Please check your input and try again."
else
    echo "DNS resolution output: $dns_check_output"
    exit 0
fi


# can try to use dig if installed
# Note the good approach with dig can be to use the concerned output flags, to have the exact output we want, and avoid the need to parse the output of nslookup, which can be more complex and less reliable.
# e.x: dig +short google.com


# if [nslooup $1 ]; then
#     echo "The provided input is a valid URL or IP address."
# else
#     echo "The provided input is not a valid URL or IP address. Please check your input and try again."
#     exit 1
# fi