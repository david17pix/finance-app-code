#!/bin/bash
export AWS_REGION=us-west-1
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export EKS_CLUSTER_NAME="pc-national-bank-kubecon"
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
aws sts get-caller-identity
export EKS_CODEBUILD_ROLE_ARN=`aws sts get-caller-identity | jq -r '.Arn'`
helm version
mkdir ~/.kube/
aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
kubectl version --output=json
echo "Setup Done !!"
