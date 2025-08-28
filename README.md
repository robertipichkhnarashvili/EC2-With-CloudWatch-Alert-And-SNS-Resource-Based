This repository contains a Terraform project that provisions EC2 instances using Resource Blocks and sets up monitoring and alerts via AWS CloudWatch and SNS.

Project Overview


EC2 Instances: Created directly using Terraform resource blocks.


CloudWatch Agent: Installed on the EC2 instances to collect metrics like CPU, memory, and disk usage.


CloudWatch Alarms: Configured to trigger when CPU utilization exceeds a defined threshold.


SNS Notifications: Integrated with CloudWatch alarms to send email notifications when thresholds are breached.


To use this project run(have git preinstalled):

1. git init

2. git clone <repository_url>


Afterwards, configure the file the way you want to, follow documentation in variables.tf to fill out the variables on your need, and also include your own key.pem to access the instance via SSH, afterwards you can run


3.terraform init

4.terraform apply