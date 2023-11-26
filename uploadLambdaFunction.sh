#!/bin/bash

#get the input values
profile=$1
repoRoot=$2
functionName=$3

echo $'\n'"Starting Migration for function $functionName"$'\n'
SCRIPTSROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#check if function is active
aws lambda wait function-active \
--function-name "$functionName" \
--profile "$profile"

#get the directory location for the function in the repo
funcDir="$repoRoot/$(echo ${functionName//*-/})"

#if function exists in repo
if [ -d "$funcDir" ]; then
    
    #navigate to function directory
    cd "$funcDir"
    
    #install any packages
    FILE=./package.json
    if [ -f "$FILE" ]; then
        :
        npm install
    fi
    
    #if an archive already exists, delete it.
    if [ -f "./$functionName.zip" ]; then
        :
        rm "$functionName.zip"
    fi
    
    #create an archive
    zip -rq "$functionName.zip" *
    
    echo "uploading "$functionName" function code"
    #wait for the function to be active
    aws lambda wait function-active \
    --function-name "$functionName" \
    --profile "$profile"
    
    #upload the function code
    
    aws lambda update-function-code \
    --function-name "$functionName" \
    --zip-file fileb://"$functionName.zip" \
    --profile "$profile" \
    --no-cli-pager 2>&1
    
    #remove the archive
    if [ -f "./$functionName.zip" ]; then
        :
        rm "$functionName.zip"
    fi
    
fi
