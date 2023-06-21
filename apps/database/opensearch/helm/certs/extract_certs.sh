#!/bin/bash

PFX_FILE="$1"
PEM_CERT="esnode.pem"
PEM_KEY="esnode-key.pem"
PEM_CA="root-ca.pem"

openssl pkcs12 -in $PFX_FILE -nocerts -nodes -out $PEM_KEY
openssl pkcs12 -in  $PFX_FILE -clcerts -nokeys -out $PEM_CERT
openssl pkcs12 -in $PFX_FILE -cacerts -nokeys -chain -out $PEM_CA
