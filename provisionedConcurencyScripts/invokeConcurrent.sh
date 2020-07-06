json_response="$(aws apigateway get-rest-apis)"
set -- "$(python2 ../getTestIDsFromApiJsonRS.py 'provisionedConcurnecy' 'name' <<< "${json_response}")"
api_id=$1
json_response="$(aws apigateway get-resources --rest-api-id $api_id )"
resource_ids="$(python2 ../getTestIDsFromApiJsonRS.py 'Test' 'path' <<< "${json_response}")"

for invokeCount in 1 2 3 4
do
    for resource_id in ${resource_ids}
    do
        python2 -c "import sys, json; print json.load(sys.stdin)['body'] , 'Invocation number $invokeCount'  " \
              <<< "$(aws apigateway test-invoke-method --rest-api-id $api_id --resource-id $resource_id --http-method 'GET' )" &
    done
done

