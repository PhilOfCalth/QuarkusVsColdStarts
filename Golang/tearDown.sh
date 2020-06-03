#!/usr/bin/env bash

aws lambda delete-function --function-name goTest

rm testLambda testLambda.zip
