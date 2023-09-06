# Terraform deployment project

Here I use terraform to deploy another public [project](https://github.com/devopshydclub/vprofile-project/tree/aws-LiftAndShift) from GitHub

## Description

This project consists of several terraform modules, that are used to deploy the following AWS infrastructure:

- VPC
- Security groups
- Subnets
- Internet gateway
- Load balancer
- Route 53 records 
- EC2 instances


## Prerequisites

To do the following steps following is needed:

- Docker
- Terraform
- AWS CLI installed and configured

## Building artifact

To build the artifact for the deployment, you need to clone this [repository](https://github.com/devopshydclub/vprofile-project/tree/aws-LiftAndShift).

Next, use this command to build the artifact using the utility container.

```bash
docker run --rm -v "$(pwd)":/usr/src/mymaven -w /usr/src/mymaven maven:3.9.4-amazoncorretto-11 mvn clean package
```

The artifact would be in the "target" folder.

## Deployment

Firstly, two modifications are needed.

- Specify S3 'bucket_name' either in 'variables.tf' or using '-var' option. (A new bucket will be created)
- Modify file 'userdata/tomcat_ubuntu.sh'. Replace "your-bucket-for-artifact" with a selected name

Then run

```bash
terraform init
```

Then, you can deploy the infrastructure.

(You would need to specify the path to the artifact.)

```bash
sudo terraform apply -var artifact_source="/path/to/the/artifact.war"
```
For more configuration modify 'variables.tf' file.

## Additional info

If you have a domain name and https certificat for it (located in AWS ACM) you can supply the domain name in variables and the certificate will be automaticly applied.


You can avoid creation of S3 bucket by specifying bucket_id in s3_artifact module in 'main.tf'

My linkedin: https://www.linkedin.com/in/mnknta/