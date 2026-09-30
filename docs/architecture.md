# Netflix-Style 3-Tier AWS Architecture

## Request flow

Users -> Application Load Balancer -> EC2 Auto Scaling Group -> Amazon RDS MySQL

## Network placement

- Public subnets in two Availability Zones: Application Load Balancer and NAT Gateways.
- Private application subnets in two Availability Zones: EC2 instances managed by the Auto Scaling Group.
- Private database subnets in two Availability Zones: Amazon RDS MySQL.

## Why this design

### High Availability
Multiple Availability Zones reduce dependence on a single Availability Zone. The Auto Scaling Group maintains multiple application instances and the load balancer routes traffic to healthy targets.

### Scalability
The Auto Scaling Group starts with two instances and can scale to four based on average CPU utilization. The Application Load Balancer distributes requests across the instances.

### Security
The internet can reach the load balancer. Application instances accept port 8080 only from the load balancer security group. RDS accepts MySQL port 3306 only from the application security group. RDS is not publicly accessible.

### Database
RDS MySQL is placed in a dedicated database subnet group spanning two Availability Zones and configured for Multi-AZ deployment.

## Interview explanation

“I designed a highly available three-tier web application on AWS. Users access the application through an Application Load Balancer in public subnets. The load balancer distributes requests across EC2 instances managed by an Auto Scaling Group in private application subnets across two Availability Zones. The application communicates with a private Multi-AZ Amazon RDS MySQL database. Security groups restrict communication between each tier, and Auto Scaling provides scalability and replacement of unhealthy instances.”

## Important AWS full forms

- AWS — Amazon Web Services
- VPC — Virtual Private Cloud
- AZ — Availability Zone
- ALB — Application Load Balancer
- EC2 — Elastic Compute Cloud
- ASG — Auto Scaling Group
- RDS — Relational Database Service
- IAM — Identity and Access Management
- NAT — Network Address Translation
- SG — Security Group
- CI/CD — Continuous Integration / Continuous Delivery
- IaC — Infrastructure as Code
- HA — High Availability
