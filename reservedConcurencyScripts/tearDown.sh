#!/usr/bin/env bash

if [ -z "$USER_PROFILE" ]
then
    aws iam detach-role-policy --role-name lambda-cli-role \
                        --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
    aws iam delete-role --role-name lambda-cli-role

    json_response="$(aws apigateway get-rest-apis)"
    aip_ids="$(python2 ../getTestIDsFromApiJsonRS.py 'quarkusVsJava-api' 'name' <<< "${json_response}")"

    for aip_id in ${aip_ids}
    do
        aws apigateway delete-rest-api --rest-api-id ${aip_id}
    done
else
    aws iam detach-role-policy --role-name lambda-cli-role --profile $USER_PROFILE \
                        --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
    aws iam delete-role --role-name lambda-cli-role  --profile $USER_PROFILE

    json_response="$(aws apigateway get-rest-apis --profile $USER_PROFILE)"
    aip_ids="$(python2 ../getTestIDsFromApiJsonRS.py 'quarkusVsJava-api' 'name' <<< "${json_response}")"

    for aip_id in ${aip_ids}
    do
        aws apigateway delete-rest-api --rest-api-id ${aip_id}  --profile $USER_PROFILE
    done
fi

cd ../Java
./tearDown.sh
cd ../Quarkus/
./tearDownGraalVM.sh
