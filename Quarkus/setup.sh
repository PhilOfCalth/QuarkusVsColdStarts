#!/usr/bin/env bash
set -e

mvn clean package > /dev/null

if [ -z "$USER_PROFILE" ]
then
    json_response="$(aws lambda create-function --function-name quarkusTest \
        --zip-file fileb://target/quarkusLambda-1.0-SNAPSHOT-runner.jar \
        --handler io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest \
        --runtime java8 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --timeout 30 )"
else
    json_response="$(aws lambda create-function --function-name quarkusTest \
        --zip-file fileb://target/quarkusLambda-1.0-SNAPSHOT-runner.jar \
        --handler io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest \
        --runtime java8 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role --profile $USER_PROFILE \
        --timeout 30 )"
fi

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
