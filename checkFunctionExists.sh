#!/bin/bash

#get the input values
profile=$1
functionName=$2

functions=$(aws lambda list-functions --profile "$profile" | jq -r .Functions[].FunctionName)
eval "functionsArr=($functions)"

functionExists=false
for function in "${functionsArr[@]}"; do
    if [ "$function" == "$functionName" ]; then
        functionExists=true
        break
    fi
done

echo "$functionExists"