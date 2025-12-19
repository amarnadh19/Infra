#######################################################################
#EKS node configuration
#######################################################################

# IAM Role for EKS Nodes
resource "aws_iam_role" "eks_nodes" {
  name = "${var.cluster_name}-node-role"

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

# Optimized Policy Attachments using for_each to reduce code repetition
resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_nodes.name
}

#############################
##### Node group
############################

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_group_name 
  node_role_arn   = aws_iam_role.eks_nodes.arn
  
  # Pass the list directly without extra brackets
  subnet_ids      = var.subnet_ids  
  
  release_version = var.release_version
  
  # Pass the list directly
  instance_types  = var.nodegroup_instance_types 

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policies
  ]
}

######################## Cluster ##################

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  # The Trust Policy: Allows the EKS service to use this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    # 1. Subnets: Pass at least two subnets in different AZs
    subnet_ids = var.subnet_ids

    # 2. Endpoint Access: 
    # Best Practice: Both True. Nodes talk to API over private network.
    # You talk to API via public endpoint (can be restricted via CIDR).
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    
    # Optional: Restrict public access to your specific IP
    # public_access_cidrs = ["your.ip.address/32"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster # This prevents "dependency violation" errors during deletion
  depends_on = [
    # Reference your IAM policy attachment resources here
     aws_iam_role_policy_attachment.eks_cluster_policy 
  ]
}

################## OIDC ######################

# Fetch the TLS certificate for the EKS OIDC provider 
# (Required to establish trust)
data "tls_certificate" "eks" {
  #url = var.provider_url
  url =  aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# Create the OIDC Provider in IAM
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  tags = {
    Name = "${var.cluster_name}-oidc-provider"
  }
}

# ###################### This role allows a pod to list S3 buckets, but only if that pod is using the specific Service Account we define.

# The IAM Policy allowing S3 Read access
resource "aws_iam_policy" "test_s3_policy" {
  name        = "EKS-S3-Read-Only"
  description = "Policy to test EKS OIDC"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

# The IAM Role with a Trust Relationship to the OIDC Provider
resource "aws_iam_role" "test_oidc_role" {
  name = "eks-test-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Condition = {
        StringEquals = {
          # Only allow the service account 'aws-test-sa' in the 'default' namespace
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub": "system:serviceaccount:default:aws-test-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.test_oidc_role.name
  policy_arn = aws_iam_policy.test_s3_policy.arn
}

################# 
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   name: aws-test-sa
#   namespace: default
#   annotations:
#     # This is the magic line that links K8s to AWS IAM
#     eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/eks-test-oidc-role

#     # 1. Apply the service account
# kubectl apply -f service-account.yaml

# # 2. Run a temporary pod to test permissions
# kubectl run aws-cli --rm -it --reuse-address --image=amazon/aws-cli --serviceaccount=aws-test-sa -- s3 ls
# ##

#############

# Fetch cluster details
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.cluster.id
  depends_on = [ aws_eks_cluster.cluster ]
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.cluster.id
  depends_on = [ aws_eks_cluster.cluster ]
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

resource "kubernetes_service_account_v1" "test_sa" {
  metadata {
    name      = "aws-test-sa"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.test_oidc_role.arn
    }
  }
}

