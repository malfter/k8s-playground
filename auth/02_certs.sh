#!/usr/bin/env bash

set -e

# show all commands
set -x

MINIKUBE_DOMAIN=$( minikube ip ).nip.io

rm -rf ssl && mkdir -p ssl

## generate certs
DOMAIN="dex.${MINIKUBE_DOMAIN}"
echo "$DOMAIN"
DNS_ENTRIES="DNS:${DOMAIN},DNS:*.${DOMAIN},DNS:*.sharded.${DOMAIN},DNS:demo-app.${MINIKUBE_DOMAIN}"
K8S_CA_CN='Local Dex Signer'
K8S_CA_KEY_FILE='ssl/ca.key'
K8S_CA_CERT_FILE='ssl/ca.pem'
K8S_SERVER_ORG='Local Dex'
K8S_SERVER_KEY_FILE='ssl/key.pem'
K8S_SERVER_CERT_REQUEST_FILE='ssl/domain.csr'
K8S_SERVER_CERT_FILE='ssl/cert.pem'

# Figure out openssl configuration file location
OPENSSL_CNF='/etc/pki/tls/openssl.cnf'
if [ ! -f $OPENSSL_CNF ]; then
    OPENSSL_CNF='/etc/ssl/openssl.cnf'
fi
openssl genrsa -out $K8S_CA_KEY_FILE 4096
openssl req -new -x509 -nodes -key $K8S_CA_KEY_FILE -sha256 \
            -subj /CN="${K8S_CA_CN}" \
            -days 1024 \
            -reqexts SAN -extensions SAN \
            -config <(cat ${OPENSSL_CNF} <(printf '[SAN]\nbasicConstraints=critical, CA:TRUE\nkeyUsage=keyCertSign, cRLSign, digitalSignature')) \
            -outform PEM -out $K8S_CA_CERT_FILE
openssl genrsa -out $K8S_SERVER_KEY_FILE 2048
openssl req -new -sha256 -key $K8S_SERVER_KEY_FILE \
            -subj "/O=${K8S_SERVER_ORG}/CN=${MINIKUBE_DOMAIN}" \
            -reqexts SAN \
            -config <(cat $OPENSSL_CNF <(printf "\n[SAN]\nsubjectAltName=${DNS_ENTRIES}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=digitalSignature, keyEncipherment, keyAgreement, dataEncipherment\nextendedKeyUsage=serverAuth")) \
            -outform PEM -out $K8S_SERVER_CERT_REQUEST_FILE
openssl x509 -req -in $K8S_SERVER_CERT_REQUEST_FILE -CA $K8S_CA_CERT_FILE -CAkey $K8S_CA_KEY_FILE -CAcreateserial \
            -days 365 \
            -sha256 \
            -extfile <(printf "subjectAltName=${DNS_ENTRIES}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=digitalSignature, keyEncipherment, keyAgreement, dataEncipherment\nextendedKeyUsage=serverAuth") \
            -outform PEM -out $K8S_SERVER_CERT_FILE
cat $K8S_SERVER_CERT_FILE $K8S_CA_CERT_FILE > ssl/kube.crt

## copy certs so minikube can see it
mkdir -p ~/.minikube/files/etc/ca-certificates/
cp ssl/ca.pem ~/.minikube/files/etc/ca-certificates/openid-ca.pem

set +x

echo
echo "Action item ===> Import 'ssl/ca.pem' into your browser <==="
echo