#!/usr/bin/env bash

mvn clean package -Dnative -Dquarkus.native.container-build=true

if [ -z "$USER_PROFILE" ]
then
    json_response="$(aws lambda create-function --function-name quarkusGraalTest --zip-file fileb://target/TestLambda.zip \
        --handler any.name.not.used --runtime provided \
        --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --environment Variables="{DISABLE_SIGNAL_HANDLERS=true}")"
else
    json_response="$(aws lambda create-function --function-name quarkusGraalTest --zip-file fileb://target/TestLambda.zip \
        --handler any.name.not.used --runtime provided \
        --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --environment Variables="{DISABLE_SIGNAL_HANDLERS=true}" \
        --profile $USER_PROFILE)"
fi

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
