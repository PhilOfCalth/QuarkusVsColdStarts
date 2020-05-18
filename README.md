# QuarkusVsColdStarts
A quick comparison between cold start times for different common languages on AWS Lambda. There is a focus on the usage of Quarkus and GraalVM, to speed up Java's cold start time.

For use in Naimuri insight/blog post:
https://www.naimuri.com/solving_java_cold_starts/

## High Level Design Principle
Deploy the test lambda's behind a restful API Gateway, with API 'proxy' activated, to allow the cold start time to be measured. Java, Python, Node and Golang have been selected to be compared. Scripts are written to create, invoke and delete everything using the AWS CLI. After initial creation, the lambdas need to be given time to go cold, before being invoked.

## Running the scripts
### Prerequisites
* Bash compatible console (anything on linux or macOS)
* Python 2
* AWS Account
* AWS CLI

Each individual script `setupAll.sh`, `invokeAll.sh` and `tearDownAll.sh` need to be called manually. The scripts require an environment variable `ACCOUNT_ID` set to your account's ID, to run. If you have set up your AWS CLI to use a profile, the scripts can be set to use it by setting the environment variable `USER_PROFILE`

Usage: `ACCOUNT_ID=<account id> [USER_PROFILE=<user profile>] ./<script>`

EG: `ACCOUNT_ID=123456789012 USER_PROFILE=testUser ./tearDownAll.sh`

## Testing a lambda without the API Gateway
If you wish to just deploy and test one of the lambdas, without the api gateway, this can be done by running the setup script within its directory. The same environment variables as above need to be set, for it to successfully complete. You can test it through the AWS console, but it will need a Test Event set up to simulate what the API gateway would send, populated with the only data we care about `requestTimeEpoch`
```
{
  "path": "/test",
  "requestContext": {
      "requestTimeEpoch": <past epoch timestamp in ms>
  }
}
```
EG:
```
{
  "path": "/test",
  "requestContext": {
      "requestTimeEpoch": 1578061743
  }
}
```

## Validity of this Test
Of course this is just one benchmark. There are no dependencies, no database connections and the code is extremely simple. Different languages, or indeed different flavors of Java may perform differently under different circumstances.
