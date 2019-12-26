#!/usr/bin/env bash

rm testLambda.zip

if [ -z "$USER_PROFILE" ]
then
    aws lambda delete-function --function-name pyhtonTest
else
    aws lambda delete-function --function-name pythonTest --profile $USER_PROFILE
fi
