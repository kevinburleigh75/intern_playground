#!/bin/bash -xe

. ~/.profile

cd /home/ec2-user
mkdir -p ping_server
cd ping_server
echo InstanceId: $AWS_INSTANCE_ID LcName: $AWS_ASG_LC_NAME LcImageId: $AWS_ASG_LC_IMAGE_ID > ping
ls
echo "starting ping server..."
python -m SimpleHTTPServer 8000

