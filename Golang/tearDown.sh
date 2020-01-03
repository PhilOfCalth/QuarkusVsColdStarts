#!/usr/bin/env bash

if [ -z "$USER_PROFILE" ]
then
    aws lambda delete-function --function-name goTest
else
    aws lambda delete-function --function-name goTest --profile $USER_PROFILE
fi

rm testLambda testLambda.zip
