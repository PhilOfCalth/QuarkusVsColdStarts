#!/usr/bin/env bash

mvn clean package -Dnative -Dquarkus.native.container-build=true  > /dev/null

if [ -z "$USER_PROFILE" ]
then
    json_response="$(aws lambda create-function --function-name quarkusGraalTest --zip-file fileb://target/function.zip \
        --handler any.name.not.used --runtime provided \
        --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --environment Variables="{DISABLE_SIGNAL_HANDLERS=true}" \
        --timeout 30 )"
else
    json_response="$(aws lambda create-function --function-name quarkusGraalTest --zip-file fileb://target/function.zip \
        --handler any.name.not.used --runtime provided \
        --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --environment Variables="{DISABLE_SIGNAL_HANDLERS=true}" \
        --profile $USER_PROFILE --timeout 30 )"
fi

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
