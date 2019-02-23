#!/bin/bash
#Description: returns true/0 if a bash contains the given word
#https://stackoverflow.com/questions/3685970/

_ArrayContainsElement() { 
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}
