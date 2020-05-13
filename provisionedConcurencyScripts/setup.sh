#!/usr/bin/env bash
set -e

export PYTHONIOENCODING=utf8

if [ -z "$ACCOUNT_ID" ]
then
    echo "You must specify a valid ACOUNT_ID. Usage:"
    echo "ACCOUNT_ID=<account id> [USER_PROFILE=<user profile>] ./setupAll.sh"
    exit 1
fi

if [[ -z "$USER_PROFILE" ]]
then
    aws iam create-role --role-name lambda-cli-role --assume-role-policy-document file://../trust-policy.json
    aws iam attach-role-policy --role-name lambda-cli-role \
                        --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

    # Root API Gateway
    json_response="$(aws apigateway create-rest-api --name "quarkusVsJava-api")"
    rest_api_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['id'] " <<< "${json_response}")
    json_response="$(aws apigateway get-resources --rest-api-id $rest_api_id)"
    root_path_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['items'][0]['id'] " <<< "${json_response}")

    function setUpAPIGateway(){
        lambda_name="$1"

        json_response="$(aws apigateway create-resource --rest-api-id $rest_api_id \
            --parent-id $root_path_id --path-part $lambda_name)"
        resource_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['id'] " <<< "${json_response}")
        aws apigateway put-method --rest-api-id $rest_api_id --resource-id $resource_id \
            --http-method GET --authorization-type NONE

        aws apigateway put-integration --rest-api-id $rest_api_id --resource-id $resource_id --http-method GET \
            --type AWS_PROXY --integration-http-method POST \
            --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/${lambda_arn}/invocations \

        aws lambda add-permission --function-name $lambda_name --statement-id $lambda_name \
            --action lambda:InvokeFunction --principal apigateway.amazonaws.com \
            --source-arn arn:aws:execute-api:eu-west-1:${ACCOUNT_ID}:${rest_api_id}/*/*/*
    }
else
    aws iam create-role --role-name lambda-cli-role --assume-role-policy-document \
                                        --profile $USER_PROFILE file://../trust-policy.json
    aws iam attach-role-policy --role-name lambda-cli-role --profile $USER_PROFILE \
                        --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

    # Root API Gateway
    json_response="$(aws apigateway create-rest-api --name "quarkusVsJava-api" --profile $USER_PROFILE)"
    rest_api_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['id'] " <<< "${json_response}")
    json_response="$(aws apigateway get-resources --rest-api-id $rest_api_id --profile $USER_PROFILE)"
    root_path_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['items'][0]['id'] " <<< "${json_response}")


    function setUpAPIGateway(){
        lambda_name="$1"

        json_response="$(aws apigateway create-resource --rest-api-id $rest_api_id \
            --parent-id $root_path_id --path-part $lambda_name --profile $USER_PROFILE)"
        resource_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['id'] " <<< "${json_response}")
        aws apigateway put-method --rest-api-id $rest_api_id --resource-id $resource_id \
            --http-method GET --authorization-type NONE --profile $USER_PROFILE

        aws apigateway put-integration --rest-api-id $rest_api_id --resource-id $resource_id --http-method GET \
            --type AWS_PROXY --integration-http-method POST \
            --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/${lambda_arn}/invocations \
            --profile $USER_PROFILE

        aws lambda add-permission --function-name $lambda_name --statement-id $lambda_name \
            --action lambda:InvokeFunction --principal apigateway.amazonaws.com \
            --source-arn arn:aws:execute-api:eu-west-1:${ACCOUNT_ID}:${rest_api_id}/*/*/*  --profile $USER_PROFILE
    }
fi

echo "### Waiting for Role to be usable ###"
sleep 10

cd ../Java
lambda_arn=$(./setup.sh)
setUpAPIGateway 'javaTest'
if [[ -z "$USER_PROFILE" ]]
then
  json_response="$(aws lambda publish-version --function-name javaTest)"
  version=$(python2 -c "import sys, json; print json.load(sys.stdin)['Version'] " <<< "${json_response}")
  aws lambda put-provisioned-concurrency-config --function-name javaTest --qualifier $version \
      --provisioned-concurrent-executions 2
else
  json_response="$(aws lambda publish-version --function-name javaTest  --profile $USER_PROFILE)"
  version=$(python2 -c "import sys, json; print json.load(sys.stdin)['Version'] " <<< "${json_response}")
  aws lambda put-provisioned-concurrency-config --function-name javaTest --profile $USER_PROFILE  \
       --qualifier $version --provisioned-concurrent-executions 2
fi

cd ../Quarkus/
echo "### Building the native linux zip from scratch with Quarkus and GraalVM... This will take a few minutes ###"
lambda_arn=$(./setupGraalVM.sh)
setUpAPIGateway 'quarkusGraalTest'
