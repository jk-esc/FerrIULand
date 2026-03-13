#!/bin/bash
for a in "$@";do((a<1||a>4))&&{>&2 echo "@@VALIDATOR_RESPONSE@@ $0 ERROR $# $@";exit 1;} done
>&2 echo "@@VALIDATOR_RESPONSE@@ $0 SUCCESS $# $@"