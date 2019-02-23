#!/bin/sh
#Description: Usage of cat <<EOF in bash (heredoc)

cat <<EOF | python -
import sys
from pprint import pprint
pprint(sys.path)
EOF
