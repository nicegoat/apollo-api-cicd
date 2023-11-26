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
    funcDir="$repoRoot/$(echo ${function//*-/})"

    #if function exists in repo and is not part of the public api
    if [ -d "$funcDir" ]; then
        echo "$function $count"
        ((count++))

        bash $SCRIPTSROOT/uploadLambdaFunction.sh "$profile" "$repoRoot" "$function"
    fi
done
