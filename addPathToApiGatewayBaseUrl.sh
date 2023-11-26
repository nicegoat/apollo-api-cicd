#!/bin/bash

#get the input values
#NEED ALL INPUT VALUES
profile="$1"
apiName="$2"
domain="$3"
stageName="$4"

apiId=$(aws apigateway get-rest-apis --profile "$profile" | jq -r --arg apiname "$apiName" '.items[] | select(.name == $apiname) | .id')

basePath=$(echo "$stageName" | sed 's/_/\./g')
basePath="v$basePath"

aws apigateway create-base-path-mapping \
    --domain-name "$domain" \
    --profile "$profile" \
    --base-path "$basePath" \
    --rest-api-id "$apiId" \
    --stage "$stageName"




#aws apigateway update-usage-plan --usage-plan-id 3gel3j --patch op="add",path="/apiStages",value="uaqu75c8d5:1_1_0" --profile rocpcicd