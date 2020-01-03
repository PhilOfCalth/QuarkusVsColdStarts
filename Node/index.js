exports.handler = async (event) => {

    const current_milli_time = new Date().getTime();
    const api_epoch_time = event['requestContext']['requestTimeEpoch'];
    const rs_body = 'Node Test Lambda took '+ (current_milli_time - api_epoch_time) +'ms to start';

    console.log(rs_body);
    const response = {
        statusCode: 200,
        body: rs_body,
    };
    return response;
};
