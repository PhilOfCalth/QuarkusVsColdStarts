#!/usr/bin/env bash
set -e

go get github.com/aws/aws-lambda-go/lambda
go get github.com/aws/aws-lambda-go/events
GOOS=linux GOARCH=amd64 go build -o testLambda TestLambda.go
zip testLambda.zip testLambda > /dev/null

if [ -z "$USER_PROFILE" ]
then
    json_response="$(aws lambda create-function --function-name goTest --zip-file fileb://testLambda.zip \
        --handler testLambda \
        --runtime go1.x --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --timeout 30 )"
else
    json_response="$(aws lambda create-function --function-name goTest --zip-file fileb://testLambda.zip \
        --handler testLambda \
        --runtime go1.x --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role --profile $USER_PROFILE \
        --timeout 30 )"
fi

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
