#!/usr/bin/env bash
set -e

zip testLambda.zip testLambda.py  > /dev/null

if [ -z "$USER_PROFILE" ]
then
    json_response="$(aws lambda create-function --function-name pythonTest --zip-file fileb://testLambda.zip \
        --handler testLambda.lambda_handler --runtime python3.8 \
        --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role \
        --timeout 30 )"
else
    json_response="$(aws lambda create-function --function-name pythonTest --zip-file fileb://testLambda.zip \
        --handler testLambda.lambda_handler --runtime python3.8 \
        --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-cli-role --profile $USER_PROFILE \
        --timeout 30 )"
fi

echo "$(python2 -c "import sys, json; print json.load(sys.stdin)['FunctionArn'] " <<< "${json_response}")"
