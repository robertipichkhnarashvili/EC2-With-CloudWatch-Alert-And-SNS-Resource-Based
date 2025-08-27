module "my_instance" {
  ami = data.aws_ami.EC2_Latest_AMI.image_id
  source = "./module-1/"
  subnet_id = aws_subnet.public.id
  instance_type = var.instance_type
  key_name = "linux_key"
  user_data = <<-EOF
      #!/bin/bash
    sudo yum update -y
    sudo yum install -y amazon-cloudwatch-agent

    cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOL
      {
        "metrics": {
        "append_dimensions": {
            "InstanceId": "\$${aws:InstanceId}"
        },
        "metrics_collected": {
            "mem": {
            "measurement": ["mem_used_percent"]
         },
            "disk": {
            "measurement": ["disk_used_percent"],
            "resources": ["*"]
            }
        }
        }
    }
    EOL

    # Start CloudWatch Agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
        -a fetch-config -m ec2 \
        -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

    sudo systemctl enable amazon-cloudwatch-agent
    EOF 
    iam_instance_profile = aws_iam_instance_profile.cloudwatch_profile.name
    vpc_security_group_ids = [aws_security_group.allow_SSH_HTTP_HTTPS.id]
}
output "instance_ids" {
  value = module.my_instance.instance_id
}