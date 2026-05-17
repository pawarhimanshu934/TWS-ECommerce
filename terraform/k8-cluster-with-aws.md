vpc_id                   = module.vpc.vpc_id
subnet_ids               = module.vpc.public_subnets
control_plane_subnet_ids = module.vpc.intra_subnets

First, what are these subnet types?

1. Public subnets

Have route to Internet Gateway

Often:
map_public_ip_on_launch = true

Used for:
Load balancers

2. Private subnets

No direct internet access
Route outbound via NAT Gateway

Used for:
Worker nodes (very common)

3. Intra subnets (important here)

Fully isolated
No Internet Gateway
No NAT Gateway
Only internal VPC communication


Why control_plane_subnet_ids = intra_subnets

This is about security and AWS EKS architecture.
Key idea:
The EKS control plane ENIs are placed in your subnets.

You are telling AWS:
👉 “Place Kubernetes API/control plane network interfaces in the most isolated subnets possible.”

Why NOT private subnets?

Private subnets still have:
Outbound internet via NAT Gateway ❗

That means:
Control plane ENIs could technically reach the internet
Slightly larger attack surface


Why intra subnets are preferred

1. Maximum isolation
No internet route at all
Only internal VPC traffic allowed

2. AWS does not require internet for control plane ENIs
Control plane is managed by AWS
These ENIs are only for:
VPC ↔ control plane communication

3. Security best practice
Follow least privilege networking
Keep control plane completely internal


Quick intuition
Public subnet → internet-facing things
Private subnet → workloads that need outbound internet
Intra subnet → things that should never touch the internet

👉 Control plane falls into the third category


control_plane_subnet_ids = module.vpc.intra_subnets
is done because:

Control plane ENIs do not need internet
Intra subnets give maximum isolation
It’s a security best practice in modern EKS setups 
 
 
                        🌐 Internet
                             │
                    ┌────────┴────────┐
                    │ Internet Gateway│
                    └────────┬────────┘
                             │
                ┌────────────┴────────────┐
                │     Public Subnets      │
                │ (module.vpc.public)     │
                │                         │
                │  ┌──────────────────┐   │
                │  │  Load Balancer   │◄──┼── Incoming traffic
                │  │ (ALB / ELB)      │   │
                │  └──────────────────┘   │
                └────────────┬────────────┘
                             │
                             ▼
                ┌────────────┴────────────┐
                │     Private Subnets     │
                │ (typically for nodes)   │
                │                         │
                │  ┌──────────────────┐   │
                │  │ Worker Nodes     │   │
                │  │ (EC2 / Fargate)  │   │
                │  └──────────────────┘   │
                │          │              │
                │          ▼              │
                │     NAT Gateway ────────┼──► Internet (outbound only)
                └────────────┬────────────┘
                             │
                             ▼
                ┌────────────┴────────────┐
                │     Intra Subnets       │
                │ (module.vpc.intra)      │
                │                         │
                │  ┌──────────────────┐   │
                │  │ EKS Control Plane│   │
                │  │ ENIs (API link)  │   │
                │  └──────────────────┘   │
                │        (No Internet)    │
                └────────────────────────┘

How to read this

🔹 Public Subnets
Host internet-facing load balancers
Directly connected to Internet Gateway

🔹 Private Subnets
Host your application workloads (worker nodes)
No inbound internet
Outbound via NAT Gateway

🔹 Intra Subnets (your key question)
Host EKS control plane ENIs
❌ No Internet Gateway
❌ No NAT Gateway
✅ Only internal VPC communication

Traffic flow (simple)
User → Internet → Load Balancer (public subnet)
Load Balancer → Worker Nodes (private subnet)
Worker Nodes ↔ Control Plane (intra subnet, internal only)

Key takeaway
Control plane is isolated in intra subnets
Workloads live in private
Exposure happens only via public load balancers



Commmand to make your kubectl use aws k8 -> 
aws eks update-kubeconfig   --region us-east-1   --name easyshop-cluster




