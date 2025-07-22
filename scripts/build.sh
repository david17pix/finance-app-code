#!/bin/bash
docker_username=$DOCKER_USERNAME
docker_pass=$DOCKER_PASS
export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export EKS_CODEBUILD_APP_NAME="aws-proserve-java-app"
export IMAGE_REPO_NAME="code2cloud-ecr"
export CODEBUILD_RESOLVED_SOURCE_VERSION=$GITHUB_SHA

IMAGE_REPO_NAME
code2cloud-ecr
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
cd app
docker login -u ${docker_username} -p ${docker_pass}
docker pull maven:3-jdk-11
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
echo $AWS_ACCESS_KEY_ID
docker build . -t $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION --build-arg AWS_REGION=$AWS_REGION -f Dockerfile
docker tag $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION
docker tag $IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
docker logout
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
