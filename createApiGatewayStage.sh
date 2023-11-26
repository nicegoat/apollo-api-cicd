#!/bin/bash

#get the input values
#NEED ALL INPUT VALUES
profile="$1"
apiName="$2"
stageName="$3"

SCRIPTSROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

apiId=$(aws apigateway get-rest-apis --profile "$profile" | jq -r --arg apiname "$apiName" '.items[] | select(.name == $apiname) | .id')

aws apigateway create-deployment \
    --rest-api-id "$apiId" \
    --stage-name "$stageName" \
    --variables "version=Latest" \
    --profile "$profile"
#deploymentId=$(aws apigateway create-deployment --rest-api-id "$prodApiId" --stage-name "$stageName" --query "id" --profile "$prodProfile")

#
#   --rest-api-id "$prodApiId" \
#    --stage-name "$stageName" \
#    --deployment-id "$deploymentId" \
#    --variables "version=Latest" \
#    --profile "$prodProfile"