# Generating Lambda Layers with OpenCV as an Example

This project illustrates how to create an AWS Lambda Layer using Python 3.7 and the Serverless Framework, with OpenCV as an example.

## USAGE:

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
layers:
  opencv37:
    path: layer
    artifact: cv2-python37.zip  # If it's already zipped, Serverless needs to know
    compatibleRuntimes:
        - python3.7  # List any runtimes to specify here

resources:
  Outputs:
    OpenCV:
        Value:
          Ref: Opencv37LambdaLayer
        Export:
          Name: Opencv37LambdaLayer
```

4. Run `sls deploy`
