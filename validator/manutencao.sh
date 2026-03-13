#!/bin/bash
a=$(((!$#))&&echo "SUCCESS"||echo "ERROR");>&2 echo "@@VALIDATOR_RESPONSE@@ $0 $a $# $@"