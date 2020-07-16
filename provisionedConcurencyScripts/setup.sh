#!/usr/bin/env bash
set -e

export PYTHONIOENCODING=utf8

if [ -z "$ACCOUNT_ID" ]; then
  echo "You must specify a valid ACOUNT_ID. Usage:"
  echo "ACCOUNT_ID=<account id> [AWS_PROFILE=<user profile>] ./setupAll.sh"
  exit 1
fi

aws iam create-role --role-name lambda-cli-role --assume-role-policy-document file://../trust-policy.json
aws iam attach-role-policy --role-name lambda-cli-role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Root API Gateway
json_response="$(aws apigateway create-rest-api --name "provisionedConcurnecy")"
rest_api_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['id'] " <<<"${json_response}")
json_response="$(aws apigateway get-resources --rest-api-id $rest_api_id)"
root_path_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['items'][0]['id'] " <<<"${json_response}")

function setUpAPIGateway() {
  lambda_name="$1"

  json_response="$(aws apigateway create-resource --rest-api-id $rest_api_id \
      --parent-id $root_path_id --path-part $lambda_name)"
  resource_id=$(python2 -c "import sys, json; print json.load(sys.stdin)['id'] " <<<"${json_response}")
  aws apigateway put-method --rest-api-id $rest_api_id --resource-id $resource_id \
      --http-method GET --authorization-type NONE

  aws apigateway put-integration --rest-api-id $rest_api_id --resource-id $resource_id --http-method GET \
      --type AWS_PROXY --integration-http-method POST \
      --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/${lambda_arn}/invocations
  aws lambda add-permission --function-name $lambda_name --statement-id $lambda_name \
      --action lambda:InvokeFunction --principal apigateway.amazonaws.com \
      --source-arn arn:aws:execute-api:eu-west-1:${ACCOUNT_ID}:${rest_api_id}/*/*/*
}

function setupAlias() {

  lambda_name="$1"
  json_response="$(aws lambda publish-version --function-name $lambda_name)"
  version=$(python2 -c "import sys, json; print json.load(sys.stdin)['Version'] " <<<"${json_response}")
  json_response="$(aws lambda create-alias --function-name $lambda_name --name provCon --function-version $version)"

  echo $(python2 -c "import sys, json; print json.load(sys.stdin)['AliasArn'] " <<<"${json_response}")

}

function setupProvisionedConcurency() {
  lambda_arn="$1"
  version="$2"

  aws lambda add-permission --function-name $lambda_arn --statement-id javaTestVersionPermission \
      --action lambda:InvokeFunction --principal apigateway.amazonaws.com \
      --source-arn arn:aws:execute-api:eu-west-1:${ACCOUNT_ID}:${rest_api_id}/*/*/* \
      #--qualifier $version

  aws lambda put-provisioned-concurrency-config --function-name $lambda_arn \
      --provisioned-concurrent-executions 2 --qualifier provCon
}

echo "### Waiting for Role to be usable ###"
sleep 10

cd ../Java
./setup.sh
lambda_arn=$(setupAlias 'javaTest')
setUpAPIGateway 'javaTest'
setupProvisionedConcurency $lambda_arn $version

cd ../Java11
./setup.sh
lambda_arn=$(setupAlias 'java11Test')
setUpAPIGateway 'java11Test'
setupProvisionedConcurency $lambda_arn $version

cd ../Python
./setup.sh
lambda_arn=$(setupAlias 'pythonTest')
setUpAPIGateway 'pythonTest'
setupProvisionedConcurency $lambda_arn $version
