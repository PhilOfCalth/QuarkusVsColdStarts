#!/usr/bin/env bash

if [ -z "$USER_PROFILE" ]
then
    aws lambda delete-function --function-name quarkusTest
else
    aws lambda delete-function --function-name quarkusTest --profile $USER_PROFILE
fi
