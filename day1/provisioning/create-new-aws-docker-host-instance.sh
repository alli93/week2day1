#!/bin/bash

#aws username
USERNAME=$(aws iam get-user --query 'User.UserName' --output text)

SECURITY_GROUP_NAME=jenkins-${USERNAME}

# Directory of ec2 instance credentials
INSTANCE_DIR="ec2_instance"

if [ -d "${INSTANCE_DIR}" ]; then
    exit
fi

[ -d "${INSTANCE_DIR}" ] || mkdir ${INSTANCE_DIR} || echo "Creating ec2 instance directory..."

# Store security group name
echo $SECURITY_GROUP_NAME > ./ec2_instance/security-group-name.txt

# Query aws for an RSA private key ec2 instance 
echo "Querying for RSA private key..."
aws ec2 create-key-pair --key-name ${SECURITY_GROUP_NAME} --query 'KeyMaterial' --output text > ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem

[ -d ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem ] || echo "Success!"


# Make the RSA key readable by owner
chmod 400 ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem

# Create security group
echo "Creating security group..."
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name ${SECURITY_GROUP_NAME} --description "security group for dev environment in EC2" --query "GroupId"  --output=text)

[ -d ${SECURITY_GROUP_ID} ] || echo "Security group created with id $SECURITY_GROUP_ID"


# Store sec. group id
echo ${SECURITY_GROUP_ID} > ./ec2_instance/security-group-id.txt

# Retrieve public ip of the machine running the script
echo "Retrieving public ip..."
MY_PUBLIC_IP=$(curl http://checkip.amazonaws.com) 
[ -d ${MY_PUBLIC_IP} ] || echo "Public ip is $MY_PUBLIC_IP"

MY_CIDR=${MY_PUBLIC_IP}/32

# Create an ingress over the public ip and port 80 for the security group.
echo "Creating ingress for sec. group $SECURITY_GROUP_NAME"
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 22 --cidr ${MY_CIDR} || echo "SSH..."
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr ${MY_CIDR} || echo "HTTP..."
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${MY_CIDR} || echo "Jenkins..."
echo "Done!"


# Create EC2 instance, add a policy for our security group, and inject an instantiation script to the instance
echo "Creating instance..."
INSTANCE_ID=$(aws ec2 run-instances --user-data file://ec2-instance-init.sh --image-id ami-9398d3e0 --security-group-ids ${SECURITY_GROUP_ID} --count 1 --instance-type t2.micro --key-name ${SECURITY_GROUP_NAME} --query 'Instances[0].InstanceId'  --output=text)
[ -d ${INSTANCE_ID} ] || echo "Successful creation. ID is $INSTANCE_ID"

# Store instance ID
echo ${INSTANCE_ID} > ./ec2_instance/instance-id.txt

# Wait until instance is fully operational
echo "The process will halt until the instance is running..."
aws ec2 wait --region eu-west-1 instance-running --instance-ids ${INSTANCE_ID}
echo "Instance is running!"

# Retrieve public name of instance
echo "Retrieving public name of instance..."
export INSTANCE_PUBLIC_NAME=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[*].Instances[*].PublicDnsName" --output=text) 
[ -d ${INSTANCE_PUBLIC_NAME} ] || echo "Public name of instance is $INSTANCE_PUBLIC_NAME"

# Store public name of instance
echo ${INSTANCE_PUBLIC_NAME} > ./ec2_instance/instance-public-name.txt

