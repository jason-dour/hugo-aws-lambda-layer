# hugo-aws-lambda-layer

AWS Lambda Layer for Hugo from gohugo.io.

## Building the Layer

1. Make certain you have the `lambci/lambda:build-go1.x` Docker image needed to build the layer.

    ``` shell
    $ docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    lambci/lambda              build-go1.x         051f7de811cf        11 days ago         2.2GB
    ```

    1. If you do not have the images, just pull them with a `docker pull` command.

1. Confirm the build directory is clean.

    ``` shell
    $ ls -1
    LICENSE
    README.md
    build.sh
    ```

1. Then execute the docker `lambci/lambda:build-go1.x` image to run the build script.

    ``` shell
    docker run --rm -it -v `pwd`:/tmp/repo --entrypoint /bin/bash lambci/lambda:build-go1.x /tmp/repo/build.sh
    ```

## Deploy the Layer

Once the layer zip file is created, you can deploy it to your AWS account with the following command:

``` shell
aws lambda publish-layer-version --layer-name "hugo-VERSION" --description "Hugo VERSION for All Runtimes" --license-info "Apache 2.0" --zip-file "fileb://hugo.zip"
```
