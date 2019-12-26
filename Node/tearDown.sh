#!/usr/bin/env bash

if [ -z "$USER_PROFILE" ]
then
    aws lambda delete-function --function-name nodeTest
else
    aws lambda delete-function --function-name nodeTest --profile $USER_PROFILE
fi
