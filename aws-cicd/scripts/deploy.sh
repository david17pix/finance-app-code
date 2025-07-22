#!/bin/bash
key_id=$(echo $AWS_KEY_ID | jq '.aws_key_id' | tr -d '"') 
key_secret=$(echo $AWS_KEY_ID | jq '.aws_key_secret' | tr -d '"')
export AWS_ACCESS_KEY_ID=$key_id
export AWS_SECRET_ACCESS_KEY=$key_secret
export AWS_REGION=$AWS_DEFAULT_REGION
export ENV="dev"
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`

helm upgrade -i $EKS_CODEBUILD_APP_NAME-$ENV helm_charts/$EKS_CODEBUILD_APP_NAME -f helm_charts/$EKS_CODEBUILD_APP_NAME/values.$ENV.yaml --set image.repository=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME --set image.tag=$CODEBUILD_RESOLVED_SOURCE_VERSION