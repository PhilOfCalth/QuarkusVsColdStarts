import json
import time


def lambda_handler(event, context):

    current_milli_time = int(round(time.time() * 1000))
    api_epoch_time = int(event['requestContext']['requestTimeEpoch'])

    rs_body = f'Python Test Lambda took {current_milli_time - api_epoch_time}ms to start'
    print(rs_body);

    return {
        'statusCode': 200,
        'body': rs_body
    }
