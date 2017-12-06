#!/bin/bash

#aws username
USERNAME=$(aws iam get-user --query 'User.UserName' --output text)

SECURITY_GROUP_NAME=jenkins-${USERNAME}

ssh -i ./ec2_instance/${SECURITY_GROUP_NAME}.pem ec2-user@$(cat ./ec2_instance/instance-public-name.txt)