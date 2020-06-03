#!/usr/bin/env bash

rm testLambda.zip
aws lambda delete-function --function-name pyhtonTest
