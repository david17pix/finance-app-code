#!/bin/bash
export AWS_REGION=us-east-1
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export ENV="dev"
export IMAGE_REPO_NAME="code2cloud-ecr"
export CODEBUILD_RESOLVED_SOURCE_VERSION=$GITHUB_SHA

export EKS_CODEBUILD_APP_NAME="aws-proserve-java-app"
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`

helm upgrade -i $EKS_CODEBUILD_APP_NAME-$ENV helm_charts/$EKS_CODEBUILD_APP_NAME -f helm_charts/$EKS_CODEBUILD_APP_NAME/values.$ENV.yaml --set image.repository=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME --set image.tag=$CODEBUILD_RESOLVED_SOURCE_VERSION
