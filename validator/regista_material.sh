#!/bin/bash
a=$((($#==2||$#==3))&&echo "SUCCESS"||echo "ERROR");>&2 echo "@@VALIDATOR_RESPONSE@@ $0 $a $# $@"