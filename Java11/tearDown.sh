#!/usr/bin/env bash

if [ -z "$USER_PROFILE" ]
then
    aws lambda delete-function --function-name java11Test
else
    aws lambda delete-function --function-name java11Test --profile $USER_PROFILE
fi
