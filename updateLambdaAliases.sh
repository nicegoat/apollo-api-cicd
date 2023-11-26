#!/bin/bash

profile=$1
repoRoot=$2
isPublic=$3

SCRIPTSROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

functions=$(aws lambda list-functions --profile "$profile" | jq -r .Functions[].FunctionName)
eval "functionsArr=($functions)"
#prodFunctions=$(aws lambda list-functions --profile $profile | jq -r .Functions[].FunctionName)
#eval "prodFunctionsarr=($prodFunctions)"
count=1
for function in "${functionsArr[@]}"; do
    #continue
    #if [ "$function" != "rocp-api-getUserLMSActive" ]; then
    #    continue
    #fi
    
    
    if [[ "$function" != *"apollo-api"* ]]; then
        continue
    fi
    
    #get the directory location for the function in the repo
    
    echo "$function $count"
    ((count++))
    #counter=0
    #while [[ "$functionExists" != "true" ]] && [ "$counter" -lt 31 ]; do
    #    echo "checking if $function exists in production."
    #    echo "bash $SCRIPTSROOT/checkFunctionExists.sh $profile $function"
    #    functionExists=$(bash $SCRIPTSROOT/checkFunctionExists.sh "$profile" "$function")
    #    echo "functionExists $functionExists"
    #    if [[ "$functionExists" != "true" ]]; then
    #        sleep 1
    #        let counter++
    #    fi
    #done
    bash $SCRIPTSROOT/updateLambdaAlias.sh "$profile" "$function" 'Latest'
    
done
