#!/bin/bash

# Get instance credentials
INSTANCE_ID=$(cat ./ec2_instance/instance-id.txt)
SECURITY_GROUP_ID=$(cat ./ec2_instance/security-group-id.txt)
SECURITY_GROUP_NAME=$(cat ./ec2_instance/security-group-name.txt)

# Terminate instance 
echo "Terminating instance..."
aws ec2 terminate-instances --instance-ids ${INSTANCE_ID}


# Wait until instance terminates
aws ec2 wait --region eu-west-1 instance-terminated --instance-ids ${INSTANCE_ID}
echo "Terminated instance $INSTANCE_ID"

# Delete security group
echo "Deleting security group..."
aws ec2 delete-security-group --group-id ${SECURITY_GROUP_ID}
echo "Security group $SECURITY_GROUP_NAME deleted"

# Delete RSA private key
echo "Deleting RSA private key..."
aws ec2 delete-key-pair --key-name ${SECURITY_GROUP_NAME}
echo "Done!"

# Cleanup instance credential directory
echo "Cleaning up..."
rm  -rf ec2_instance
echo "Finished deleting and cleaning up instance!"