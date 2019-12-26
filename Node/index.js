exports.handler = async (event) => {
    console.log("Node Test Lambda!");
    const response = {
        statusCode: 200,
        body: JSON.stringify('Node Test Lambda!'),
    };
    return response;
};
