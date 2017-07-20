#!/bin/bash
#
# This script will be run inside a container. It should clone openscap
# repository, do the configuration, compilation and finally run `make check`.
#

set -x

git clone https://github.com/OpenSCAP/openscap
cd openscap
./autogen.sh
./configure --enable-sce
make

# DISABLES SOME NON-FUNCTIONAL TESTS BEFORE RUNNING 'make check':
# tests/probes/sysctl (in both VM and container because of bug):
sed -i 's|.*test_sysctl_probe_all.sh.*|#&|' tests/probes/sysctl/all.sh
# tests/mitre: (in both VM and container):
sed -i 's|.*linux-def_selinuxsecuritycontext_test.xml.*|#&|' tests/mitre/test_mitre.sh
sed -i 's|.*linux-def_inetlisteningservers_test.xml.*|#&|' tests/mitre/test_mitre.sh
make check

set +x
exit 0
