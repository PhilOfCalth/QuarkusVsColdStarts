#!/usr/bin/env bash

mvn clean package > /dev/null

json_response="$(aws lambda create-function --function-name java11Test --zip-file fileb://target/lambda-java11-1.0-SNAPSHOT.jar \
    --handler poc.TestLambda::handleRequest \
    --runtime java11 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role --timeout 300 )"

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
