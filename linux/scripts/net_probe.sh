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

ports=(80 443 3306)
target_ip=$dns_check_output
for port in "${ports[@]}"; do
    if nc -zv $target_ip $port >/dev/null 2>&1; then
        echo "Port $port is open on $target_ip."
    else
        echo "Port $port is closed on $target_ip."
    fi
done