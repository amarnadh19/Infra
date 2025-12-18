This is infra code.

Modules tested:

ECR -- Amar
Network. -- Lavanya


Modules need to test:

Securitygroup


Modules yet to develop:

eks


VPC Module: The foundation (Subnets, IGW, NAT).

EKS Node Module: The worker nodes and their IAM roles.

OIDC Provider: The trust bridge between K8s and IAM.

Kubernetes/Helm Providers: The tools to manage apps inside the cluster.

LBC Controller: The link between K8s Ingress and AWS ALBs.


Architecture
Networking: VPC with 2 Public/Private subnets across 2 AZs.

Compute: Managed Node Groups (t3.medium).

Identity: OIDC Provider enabled for IAM Roles for Service Accounts (IRSA).

Add-ons: AWS Load Balancer Controller (managed via Helm).