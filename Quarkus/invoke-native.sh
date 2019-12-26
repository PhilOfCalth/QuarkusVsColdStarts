aws lambda invoke --function-name quarkusGraalTest \
 --payload file://payload.json out --log-type Tail \
 --query 'LogResult' --output text --profile devUser |  base64 -d
