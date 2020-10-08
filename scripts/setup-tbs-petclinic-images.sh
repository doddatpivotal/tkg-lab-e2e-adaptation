#! /usr/bin/env bash

set -euo pipefail

ytt -f tbs/images -f local-config.yaml \
| kapp deploy -a petclinic-tbs-images -f- -y