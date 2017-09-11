#!/bin/bash
#
# This script will be run inside a container. It should clone openscap
# repository, do the configuration, compilation and finally run
# `make distcheck`.
#

set -x

git clone https://github.com/OpenSCAP/openscap
cd openscap
./autogen.sh
source <( rpm --eval '%configure --enable-sce' )
make

# Sendmail service is required by tests/mitre.
systemctl start sendmail.service
make distcheck
rv=$?

set +x
exit $rv
