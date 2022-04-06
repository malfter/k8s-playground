#!/usr/bin/env bash

set -e

echo "IMPORTANT"
echo "========="
echo "We suggest that minikube is not using Docker as a driver for this demo!"
echo "It might cause problems with ingress and DNS."
echo "Because of that, we'll be using a magic DNS called nip.io in the demo."
echo "We certainly suggest you use VirtualBox driver."
echo ""

if [ "$(arch)" == "arm64" ] && [ "$(uname -s)" == "Darwin" ]; then
  echo "[ERROR] VirtualBox and Parallels not supported on Darwin/arm64!"
  exit 1
else
  MINIKUBE_DRIVER=virtualbox
fi

# show all commands
set -x

minikube --memory 6gb --driver $MINIKUBE_DRIVER start

minikube addons enable ingress
