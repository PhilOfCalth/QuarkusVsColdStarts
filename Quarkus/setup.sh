#!/usr/bin/env bash
set -e

mvn clean package > /dev/null

json_response="$(aws lambda create-function --function-name quarkusTest \
    --zip-file fileb://target/quarkusLambda-1.0-SNAPSHOT-runner.jar --handler poc.TestLambda::handleRequest \
    --runtime java8 --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
    --timeout 30 )"

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
