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
fi

ports=(80 443 1234)
timeout=10

for port in "${ports[@]}"; do
    if nc -zvw $timeout $dns_check_output $port; then
        echo "Port $port is open on $dns_check_output"
    else
        echo "Port $port is closed on $dns_check_output"
    fi
done

echo "HTTP status code: $(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 https://google.com)"

exit 0