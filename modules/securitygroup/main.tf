#resource "aws_security_group" "this" {
#  vpc_id = var.vpc_id
#  name = "eks"
#  # Best Practice: Tag for EKS discovery
#  tags = {
#    "Name"                               = "eks-node-sg"
#    "kubernetes.io/cluster/var.cluster" = "owned"
#  }
#
#}
#
#resource "aws_vpc_security_group_ingress_rule" "allow_22" {
#  count = length(var.port)
#  security_group_id = aws_security_group.this.id
#  cidr_ipv4         = var.default_route_cidr #"0.0.0.0/0"
#  #from_port         = var.port #22
#  from_port   = var.port[count.index]
#  to_port     = var.port[count.index]
#  ip_protocol       = var.ingress_protocol #"tcp"
#  #to_port           = var.port #22
#}
#
#resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#  security_group_id = aws_security_group.this.id
#  cidr_ipv4         =  var.default_route_cidr
#  ip_protocol       = var.egress_protocol
#}

################# new code
resource "aws_security_group" "this" {
  name        = "eks-node-sg"
  vpc_id      = var.vpc_id

  # We use the merge function to combine standard tags with the dynamic EKS tag
  tags = merge(
    {
      "Name" = "eks-node-sg"
    },
    {
      # Dynamic key: the parentheses tell Terraform to evaluate the variable first
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}

# RULE 1: Allow Nodes to talk to each other (Essential for Pod-to-Pod)
resource "aws_vpc_security_group_ingress_rule" "self_reference" {
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = aws_security_group.this.id
  ip_protocol                  = "-1" # All traffic
  description                  = "Allow nodes to communicate with each other"
}

# RULE 2: Allow Control Plane to reach Kubelet (PORT 10250)
# This is much safer than 0.0.0.0/0
resource "aws_vpc_security_group_ingress_rule" "control_plane_kubelet" {
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.cluster_sg_id # The SG created by EKS
  from_port                    = 10250
  to_port                      = 10250
  ip_protocol                  = "tcp"
  description                  = "Allow EKS control plane to reach Kubelet"
}

# RULE 3: Allow Control Plane to reach Pods (Webhook/Extension API)
resource "aws_vpc_security_group_ingress_rule" "control_plane_pods" {
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.cluster_sg_id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "Allow EKS control plane to reach HTTPS pods"
}

# RULE 5: Allow SSH/Instance Connect (PORT 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0" # Use a specific IP or "0.0.0.0/0" for public testing
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH and EC2 Instance Connect"
}


# RULE 4: Egress (Allow nodes to pull images/talk to AWS API)
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# NEW RULE: The "Missing Link" for registration
#Your current code tells the Nodes how to receive traffic, but it doesn't tell the EKS Control Plane (the "cluster brain") to accept the registration request from the nodes on port 443.
resource "aws_vpc_security_group_ingress_rule" "cluster_api_from_nodes" {
  # This tells the automatically created Cluster SG to accept traffic
  security_group_id            = var.cluster_sg_id

  # This is your Node SG ID
  referenced_security_group_id = aws_security_group.this.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow nodes to reach the cluster API server for registration"
}