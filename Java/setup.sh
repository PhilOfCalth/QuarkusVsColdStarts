#!/usr/bin/env bash

mvn clean package > /dev/null

if [ -z "$USER_PROFILE" ]
then
    json_response="$(aws lambda create-function --function-name javaTest --zip-file fileb://target/lambda-java-1.0-SNAPSHOT.jar \
        --handler poc.TestLambda::handleRequest \
        --runtime java8 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --timeout 30 )"
else
    json_response="$(aws lambda create-function --function-name javaTest --zip-file fileb://target/lambda-java-1.0-SNAPSHOT.jar \
        --handler poc.TestLambda::handleRequest \
        --runtime java8 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role --profile $USER_PROFILE \
        --timeout 300 )"
fi

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
