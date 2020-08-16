# Generating Lambda Layers with OpenCV as an Example

This project illustrates how to create an AWS Lambda Layer using Python 3.7 and the Serverless Framework, with OpenCV as an example.

## USAGE:

### Preliminary AWS CLI Setup: 
1. Install [Docker](https://docs.docker.com/), the [AWS CLI](https://aws.amazon.com/cli/), and [jq](https://stedolan.github.io/jq/) on your workstation.
2. Setup credentials for AWS CLI (see http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).
3. Create IAM Role with Lambda and S3 access:
```
# Create a role with S3 and Lambda exec access
ROLE_NAME=lambda-opencv_study
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document '{"Version":"2012-10-17","Statement":{"Effect":"Allow","Principal":{"Service":"lambda.amazonaws.com"},"Action":"sts:AssumeRole"}}'
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --role-name $ROLE_NAME
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole --role-name $ROLE_NAME
```

### Build OpenCV library using Docker

AWS Lambda functions run in an [Amazon Linux environment](https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html), so libraries should be built for Amazon Linux. You can build Python-OpenCV libraries for Amazon Linux using the provided Dockerfile, like this:

```
git clone https://github.com/iandow/opencv_aws_lambda
cd opencv_aws_lambda
docker build --tag=lambda-layer-factory:latest .
docker run --rm -it -v $(pwd):/data lambda-layer-factory cp /packages/cv2-python37.zip /data
```

Edit the Dockerfile to run whatever operations needed to install your package(s) within the Docker container.

### Deploy with Serverless Framework
Derived from [these instructions](https://www.serverless.com/blog/publish-aws-lambda-layers-serverless-framework) 

1. Create a new Serverless application:
```
$ sls create -t aws-python3 -n <name> -p <path>
```

2. Move the generated zip file from this directory to your Serverless app path from above:
```
$ mv cv2-python37.zip ../<path>
```

3. Edit your `serverless.yml` to look like the following:
```yaml
service: opencv-layer

provider:
  name: aws
  runtime: python3.7
layers:
  opencv37:
    path: layer

resources:
  Outputs:
    OpenCV:
        Value:
          Ref: Opencv37LambdaLayer
        Export:
          Name: Opencv37LambdaLayer
```

4. Run `sls deploy`
