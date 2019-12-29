exports.handler = async (event) => {

    val current_milli_time = new Date().getTime();
    val api_epoch_time = event['requestContext']['requestTimeEpoch']
    rs_body = f'Node Test Lambda took {current_milli_time - api_epoch_time}ms to start'

    console.log(rs_body;
    const response = {
        statusCode: 200,
        body: JSON.stringify(rs_body),
    };
    return response;
};
