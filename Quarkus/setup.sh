#!/usr/bin/env bash

mvn clean package

if [ -z "$USER_PROFILE" ]
then
    json_response="$(aws lambda create-function --function-name quarkusTest \
        --zip-file fileb://target/quarkusLambda-1.0-SNAPSHOT-runner.jar \
        --handler io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest \
        --runtime java8 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role)"
else
    json_response="$(aws lambda create-function --function-name quarkusTest \
        --zip-file fileb://target/quarkusLambda-1.0-SNAPSHOT-runner.jar \
        --handler io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest \
        --runtime java8 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role --profile $USER_PROFILE)"
fi

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
