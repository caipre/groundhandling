#!/bin/bash

for yml in App/Resources/Licenses/*.yaml ; do
   rq <"$yml" -yJ ; done | jq --slurp . >App/Resources/licenses.json
