#!/bin/bash

PFX_FILE="$1"
PEM_CERT="esnode.pem"
PEM_KEY="esnode-key.pem"
PEM_CA="root-ca.pem"
PEM_CERT_X509="esnode-x509.pem"
PEM_KEY_X509="esnode-key-x509.pem"
PEM_CA_X509="root-ca-x509.pem"

openssl pkcs12 -in $PFX_FILE -nocerts -nodes -out $PEM_KEY
openssl pkcs12 -in  $PFX_FILE -clcerts -nokeys -out $PEM_CERT
openssl pkcs12 -in $PFX_FILE -cacerts -nokeys -chain -out $PEM_CA

openssl x509 -in $PEM_CERT -out $PEM_CERT_X509
openssl x509 -in $PEM_CA -out $PEM_CA_X509
