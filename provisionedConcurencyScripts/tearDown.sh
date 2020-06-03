#!/usr/bin/env bash

aws iam detach-role-policy --role-name lambda-cli-role \
                    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws iam delete-role --role-name lambda-cli-role

json_response="$(aws apigateway get-rest-apis)"
aip_ids="$(python2 ../getTestIDsFromApiJsonRS.py 'provisionedConcurnecy' 'name' <<< "${json_response}")"

for aip_id in ${aip_ids}
do
  aws apigateway delete-rest-api --rest-api-id ${aip_id}
done

cd ../Java
./tearDown.sh
cd ../Java11
./tearDown.sh
cd ../Python/
./tearDown.sh
