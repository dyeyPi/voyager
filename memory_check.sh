#! /bin/bash

free
TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }' )
echo $TOTAL_MEMORY
