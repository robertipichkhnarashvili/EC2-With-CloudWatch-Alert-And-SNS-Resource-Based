module "my_instance" {
  ami = data.aws_ami.EC2_Latest_AMI.image_id
  source = "./module-1/"
  subnet_id = aws_subnet.public.id
  instance_type = var.instance_type
  private_key = file("./linux_key.pem")
  key_name = "linux_key"
user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y amazon-cloudwatch-agent

    cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOL
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "\$${aws:InstanceId}"
    },
    "metrics_collected": {
      "CPU": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60,
        "totalcpu": true
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["disk_used_percent"],
        "resources": ["*"],
        "metrics_collection_interval": 60
      }
    }
  }
} 
  
  yum install -y amazon-ssm-agent
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent


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