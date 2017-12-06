INSTANCE_ID=$(cat ./ec2_instance/instance-id.txt)
INSTANCE_PUBLIC_NAME=$(cat ./ec2_instance/instance-public-name.txt)
SECURITY_GROUP_NAME=$(cat ./ec2_instance/security-group-name.txt)

echo "Checking status of EC2 instance..."
status='unknown'
while [ ! "${status}" == "ok" ]
do
   status=$(ssh -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem"  -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 ec2-user@${INSTANCE_PUBLIC_NAME} echo ok 2>&1)
   sleep 2
done
echo "Status is okay!"

echo "Deploying to ${INSTANCE_PUBLIC_NAME}"
echo "Copying docker-compose.yml to EC2 instance"
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ./docker-compose.yml ec2-user@${INSTANCE_PUBLIC_NAME}:~/docker-compose.yml
echo "Copying docker-compose-and-run..sh to EC2 instance"
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ./docker-compose-and-run.sh ec2-user@${INSTANCE_PUBLIC_NAME}:~/docker-compose-and-run.sh
echo "Copying .env to EC2 instance"
scp -o StrictHostKeyChecking=no -i "./ec2_instance/${SECURITY_GROUP_NAME}.pem" ../.env ec2-user@${INSTANCE_PUBLIC_NAME}:~/.env

aws ec2 associate-iam-instance-profile --instance-id $(cat ./ec2_instance/instance-id.txt) --iam-instance-profile Name=CICDServer-Instance-Profile