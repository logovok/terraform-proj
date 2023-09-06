#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-11-jdk -y
sudo apt install tomcat9 tomcat9-admin tomcat9-docs tomcat9-common git -y
sudo apt install awscli -y

sudo aws s3 cp s3://your-bucket-for-artifact/artifact.war /tmp/
sudo systemctl stop tomcat9
sudo sleep 5
sudo rm -rf /var/lib/tomcat9/webapps/ROOT
sudo cp /tmp/artifact.war /var/lib/tomcat9/webapps/ROOT.war
sudo sleep 5
sudo systemctl start tomcat9