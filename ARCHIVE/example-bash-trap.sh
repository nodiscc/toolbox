#!/bin/bash
#Description: usage of exit traps in bash

function finish {
  rm -rf "$scratch"
}

# trap the EXIT signal and run the finish() function
trap finish EXIT