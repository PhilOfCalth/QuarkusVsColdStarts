#!/usr/bin/env bash

json_response="$(aws apigateway get-rest-apis )"
set -- "$(python2 getTestIDsFromApiJsonRS.py 'quarkusVsJava-api' 'name' <<< "${json_response}")"
api_id=$1
json_response="$(aws apigateway get-resources --rest-api-id $api_id)"
resource_ids="$(python2 getTestIDsFromApiJsonRS.py 'Test' 'path' <<< "${json_response}")"

for resource_id in ${resource_ids}
do
    json_response="$(aws apigateway test-invoke-method --rest-api-id $api_id --resource-id $resource_id --http-method "GET" )"

    echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['body'] " <<< "${json_response}")"
    echo
done
