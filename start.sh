#!/bin/bash

repoRoot='/Users/arowland/projects/NodeJs/rest.api.roc-p.com'
profile=rocpcicd
stageName="1_1_0"
apiName="rocp-rest-api"
domain=rest.roc-p.com

SCRIPTSROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "starting migration of $apiName with stage $stageName.\n"
#create/upload any new layers to prod
#bash uploadLambdaLayers.sh $profile $repoRoot

#migrate function updates from dev to prod
bash $SCRIPTSROOT/uploadLambdaFunctions.sh "$profile" "$repoRoot"

#bash $SCRIPTSROOT/updateLambdaAliases.sh "$profile" "$repoRoot"

exit
#migrate api-gateway updates to prod
#bash $SCRIPTSROOT/migrateApiGateway.sh "$profile" "$profile" "$apiName"

#create/update the stage with the new updates
#bash $SCRIPTSROOT/createApiGatewayStage.sh "$profile" "$apiName" "$stageName"

#bash $SCRIPTSROOT/addStageToUsagePlan.sh "$profile" "$apiName" "$stageName"

#bash $SCRIPTSROOT/addPathToApiGatewayBaseUrl.sh "$apiName" "$domain" "$stageName"

exit




