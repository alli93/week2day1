# AWS CLI:

First I installed the AWS CLI using pip:

sudo apt install python-pip
pip install awscli --upgrade --user
aws configure

# Manual EC2 instance creation
After a lot of sweat and tears I realized the actual user credentials
needed were not the same as used for logging into the IAM console.
Rather a specific generated key accesed from my user's page on Amazon.
This only became apparent when creating the ec2 generation script.

Then I proceeded to manually set up an EC2 instance. This was done using a 
provided student account for the service. Initially this proved to be a barrier
since I was refused permission to create a security group, key-pair or the instance itself.
However after checking the student policy markup I found out we were expressly only given
permission to act within the Ireland eu-west-1 region. After having the machine up and running 
I made an SSH connection with it using the private RSA key created:

ssh -i top-secret.pem ec2-user@34.250.16.181

Installed platforms and dependencies for running the container:

sudo yum update -y
sudo yum install -y docker
sudo service docker start

And then pulled the image from the remote docker repository which I had pushed on day 2:

docker run -d -p 80:3000 alli93/week1:part2

Since the app listens to port 3000, the should command map EC2 port 80 to docker port 3000.

# Automatic EC2 creation and deletion
I edited the supplied script given to echo useful information, and
puzzled together functional scripts for EC2 instance creation and deletion.
This is as far as I got. A large amount of time - something around half a dozen hours - 
were wasted on dealing with AWS processes that could've been explained better. Supplied user account credentials, permissions
and configuration most notably. Though I am grateful for not having to deal with setting up an entire account by myself
in the jungles of Amazon. 