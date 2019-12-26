#!/usr/bin/env bash

if [ -z "$USER_PROFILE" ]
then
    aws lambda delete-function --function-name javaTest
else
    aws lambda delete-function --function-name javaTest --profile $USER_PROFILE
fi
