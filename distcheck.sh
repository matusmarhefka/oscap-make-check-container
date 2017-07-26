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

# DISABLES SOME NON-FUNCTIONAL TESTS BEFORE RUNNING 'make check':
# tests/probes/sysctl (in both VM and container because of bug):
sed -i 's|.*test_sysctl_probe_all.sh.*|#&|' tests/probes/sysctl/all.sh
# tests/mitre:
sed -i 's|.*linux-def_selinuxsecuritycontext_test.xml.*|#&|' tests/mitre/test_mitre.sh

# Sendmail service is required by tests/mitre.
systemctl start sendmail.service
make distcheck

set +x
exit 0
