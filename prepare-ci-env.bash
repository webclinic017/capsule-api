#!/bin/bash

PY_VERSION=${1:-3.12}

echo "Preparing this jobs with python${PY_VERSION}..."

DEBIAN_FRONTEND=noninteractive apt-get update -qy
DEBIAN_FRONTEND=noninteractive apt-get install -y python${PY_VERSION} python3-pip python3-venv

python3 -mvenv venv --upgrade-deps
. venv/bin/activate
pip install -r requirements.txt -r test-requirements.txt
