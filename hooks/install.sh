#!/bin/bash

for hook in hooks/*; do
   if [[ $hook == hooks/install.sh ]]; then continue; fi
   if [[ $@ == check ]]; then
      diff $hook .git/$hook &>/dev/null || exit 1
   else
      cp $hook .git/$hook
   fi
done
