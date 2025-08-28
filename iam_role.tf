# Creating IAM role 
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "ec2_cloudwatch_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}
#CloudWatch Agent Policy
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name        = "CWAgentPolicy"
  description = "policy for Cloudwatch agents permissions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:DescribeParameters"
        ]
        Resource = "arn:aws:ssm:${var.default_region}:${data.aws_caller_identity.current.account_id}:parameter/AmazonCloudWatch-*"
      }
    ]
  })
}
# Attaching the policy to the cloudwatch's role 
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}
# Creating instance profile for the cloudwatch agents role
resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "cloudwatch-agent-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}