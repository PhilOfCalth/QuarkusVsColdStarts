package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
    Name string `json:"name"`
}

func HandleRequest(ctx context.Context, name MyEvent) (string, error) {
    fmt.Println("Go Test Lambda!")
    return "Go Test Lambda!", nil
}

func main() {
    lambda.Start(HandleRequest)
}
