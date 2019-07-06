#!/bin/bash
vault policy list | grep -q admin || echo 'first add policy admin'
if [ -z "$1" ]
then
    echo "Usage $0 <user>"
    exit 1
fi
newuser=$1
echo -n Password: 
read -s password
echo
vault auth list| grep -q userpass || vault auth enable userpass

vault write auth/userpass/users/$newuser \
    password=$password \
    policies=admin
