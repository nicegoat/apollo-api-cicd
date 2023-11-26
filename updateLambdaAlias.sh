#!/bin/bash

#This script will publish a new version of any changed Lambda function and assign it the specified alias. If no changes were made to the Lambda function code, it will create the specified alias and assign it to the most recently published numbered version of the function

profile="$1"
functionName="$2"
AliasName="$3"

#publish a new version
echo "Publishing new version"
aws lambda wait function-active --function-name "$functionName" --profile "$profile"
version=$(aws lambda publish-version --function-name "$functionName" --profile "$profile" | jq -r ".Version")

#check if alias exists
echo "checking if alias exists"
aws lambda wait function-active --function-name "$functionName" --profile "$profile"
aliasQuery="Aliases[?Name=='$AliasName'].Name | [0]"
#aliasQuery="Aliases[?Name=='$AliasName'] | [0]"

aliasNameQueryResult=$(aws lambda list-aliases --function-name "$functionName" --profile "$profile" --query "$aliasQuery")
aliasNameQueryResult=$(echo "$aliasNameQueryResult" | sed 's/"//g')


if [[ "$aliasNameQueryResult" != "$AliasName" ]]; then
    echo "creating alias $AliasName for $functionName"
    aws lambda wait function-active --function-name "$functionName" --profile "$profile"
    aws lambda create-alias --function-name "$functionName" --name "$AliasName" --function-version "$version" --profile "$profile" --no-cli-pager
else
    echo "updating alias $AliasName for $functionName"
    aws lambda wait function-active --function-name "$functionName" --profile "$profile"
    aws lambda update-alias --function-name "$functionName" --name "$AliasName" --function-version "$version" --profile "$profile" --no-cli-pager
fi
