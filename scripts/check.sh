#!/bin/bash
export AWS_REGION=us-east-1
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export ENV="dev"
export EKS_CODEBUILD_APP_NAME="aws-proserve-java-app"
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
bash -c "if [ /"$CODEBUILD_BUILD_SUCCEEDING/" == /"0/" ]; then exit 1; fi"
sleep 60
JAVA_APP_ENDPOINT=`kubectl get svc $EKS_CODEBUILD_APP_NAME-$ENV -o jsonpath="{.status.loadBalancer.ingress[*].hostname}"`
echo -e "\nThe Java application can be accessed nw via http://$JAVA_APP_ENDPOINT"
