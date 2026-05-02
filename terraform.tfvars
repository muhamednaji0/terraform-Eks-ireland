project_name = "my-eks-project"
environment  = "dev"
aws_region   = "eu-west-1"

vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["eu-west-1a", "eu-west-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
enable_nat_gateway   = true
single_nat_gateway   = true
enable_dns_hostnames = true
enable_dns_support   = true

cluster_version           = "1.31"
node_group_desired_size   = 1
node_group_min_size       = 1
node_group_max_size       = 2
node_instance_types       = ["t3.small"]
node_disk_size            = 20
enable_cluster_encryption = true
cluster_log_types         = ["api", "audit", "authenticator"]

allowed_ssh_ips = ["0.0.0.0/0"]

additional_iam_users = [
  {
    userarn  = "arn:aws:sts::042743439464:assumed-role/jenkins_role/i-0a59c0e1f6cbb28df"
    username = "jenkins"
    groups   = ["system:masters"]
  }
]

additional_iam_roles = []

tags = {
  Project     = "EKS-Infrastructure"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "DevOps-Team"
}
