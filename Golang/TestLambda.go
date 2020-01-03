package main

import (
	"context"
	"fmt"
	"time"
	"strconv"
    "github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, request events.APIGatewayWebsocketProxyRequest) (events.APIGatewayProxyResponse, error) {

    currentTime := int64(time.Now().UnixNano() / int64(time.Millisecond))
    apiEpochTime := request.RequestContext.RequestTimeEpoch
    rsBody := "Go Test Lambda took " + strconv.FormatInt((currentTime - apiEpochTime), 10) + "ms to start";

    fmt.Println(rsBody)
    return events.APIGatewayProxyResponse{Body: rsBody, StatusCode: 200}, nil
}

func main() {
    lambda.Start(HandleRequest)
}
