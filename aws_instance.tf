resource "aws_instance" "my_instance" {
  ami = data.aws_ami.EC2_Latest_AMI.image_id
  subnet_id = aws_subnet.public.id
  instance_type = var.instance_type
  key_name = "key"
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
        "resources" : ["*"],
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
    sudo systemctl start amazon-cloudwatch-agent
EOF

  iam_instance_profile = aws_iam_instance_profile.cloudwatch_profile.name
  vpc_security_group_ids = [aws_security_group.allow_SSH_HTTP_HTTPS.id]
  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("key.pem")
  }
  provisioner "remote-exec" {
        inline = [
      "sudo amazon-linux-extras install epel -y",
      "sudo yum install stress -y",
      "sudo nohup stress --cpu 8 --timeout 800 >/dev/null 2>&1 &"
    ]
  }
}