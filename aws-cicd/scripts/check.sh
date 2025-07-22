#!/bin/bash
key_id=$(echo $AWS_KEY_ID | jq '.aws_key_id' | tr -d '"') 
key_secret=$(echo $AWS_KEY_ID | jq '.aws_key_secret' | tr -d '"')
export AWS_ACCESS_KEY_ID=$key_id
export AWS_SECRET_ACCESS_KEY=$key_secret
export AWS_REGION=$AWS_DEFAULT_REGION
export ENV="dev"
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
bash -c "if [ /"$CODEBUILD_BUILD_SUCCEEDING/" == /"0/" ]; then exit 1; fi"
sleep 60
JAVA_APP_ENDPOINT=`kubectl get svc $EKS_CODEBUILD_APP_NAME-$ENV -o jsonpath="{.status.loadBalancer.ingress[*].hostname}"`
echo -e "\nThe Java application can be accessed nw via http://$JAVA_APP_ENDPOINT"