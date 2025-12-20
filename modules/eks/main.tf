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



