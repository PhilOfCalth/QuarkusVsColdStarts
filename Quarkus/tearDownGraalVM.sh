#!/usr/bin/env bash

if [ -z "$USER_PROFILE" ]
then
    aws lambda delete-function --function-name quarkusGraalTest
else
    aws lambda delete-function --function-name quarkusGraalTest --profile $USER_PROFILE
fi
