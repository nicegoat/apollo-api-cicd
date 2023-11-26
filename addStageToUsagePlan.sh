#!/bin/bash

#get the input values
#NEED ALL INPUT VALUES
profile="$1"
apiName="$2"
stageName="$3"

usagePlanId=$(aws apigateway get-usage-plans --profile "$profile" --query "items[?name=='apollo-api'] | [0]" | jq -r '.id')

apiId=$(aws apigateway get-rest-apis --profile "$profile" | jq -r --arg apiname "$apiName" '.items[] | select(.name == $apiname) | .id')

patchOP="op=\"add\",path=\"/apiStages\",value=\"$apiId:$stageName\""
aws apigateway update-usage-plan \
    --usage-plan-id "$usagePlanId" \
    --patch "$patchOP" \
    --profile "$profile"



#aws apigateway update-usage-plan --usage-plan-id 3gel3j --patch op="add",path="/apiStages",value="uaqu75c8d5:1_1_0" --profile rocpcicd