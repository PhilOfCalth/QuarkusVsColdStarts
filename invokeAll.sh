#!/usr/bin/env bash

json_response="$(aws apigateway get-rest-apis --profile $USER_PROFILE)"
set -- "$(python2 getTestIDsFromApiJsonRS.py 'quarkusVsJava-api' 'name' <<< "${json_response}")"
api_id=$1
json_response="$(aws apigateway get-resources --rest-api-id $api_id --profile $USER_PROFILE)"
resource_ids="$(python2 getTestIDsFromApiJsonRS.py 'Test' 'path' <<< "${json_response}")"

for resource_id in ${resource_ids}
do
    aws apigateway test-invoke-method --rest-api-id $api_id --resource-id $resource_id --http-method "GET" \
                             --profile $USER_PROFILE

    # curl https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging/books
    echo
done
