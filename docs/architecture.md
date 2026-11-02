# Netflix-Style 3-Tier AWS Architecture

## Request flow

Users -> Route 53 (optional custom DNS) -> Public Application Load Balancer -> Web EC2 Auto Scaling Group (Nginx) -> Internal Application Load Balancer -> Application EC2 Auto Scaling Group (Spring Boot) -> Amazon RDS MySQL Multi-AZ.

## Network placement

- Public subnets in two Availability Zones: internet-facing ALB and NAT Gateways.
- Private web subnets in two Availability Zones: Nginx web instances and internal ALB.
- Private application subnets in two Availability Zones: Spring Boot instances managed by an Auto Scaling Group.
- Private database subnets in two Availability Zones: Amazon RDS MySQL Multi-AZ.

## Tier-to-tier security

- Internet -> public ALB: TCP 80 (TCP 443 is allowed by the security group, but HTTPS listener/certificate must be configured separately).
- Public ALB -> web instances: TCP 80.
- Web instances -> internal ALB: TCP 80.
- Internal ALB -> application instances: TCP 8080.
- Application instances -> RDS: TCP 3306.
- RDS is not publicly accessible.

## High availability and scalability

- Web and application Auto Scaling Groups span two Availability Zones.
- Each group has a minimum and desired capacity of two and a maximum of four.
- ALB target groups use HTTP health checks.
- Application and web Auto Scaling Groups use CPU target tracking.
- RDS is configured for Multi-AZ and automated backups.

## Monitoring and operations

- EC2 instances use an IAM instance profile for Systems Manager and Secrets Manager access.
- CloudWatch integration and alarms still need to be completed and tested.
- Route 53 custom DNS is optional and requires a registered domain and hosted zone.

## Interview explanation

“I designed a highly available three-tier web application on AWS. Users reach an internet-facing Application Load Balancer, which distributes requests to Nginx web servers in private subnets across two Availability Zones. The web tier forwards API requests through an internal load balancer to Spring Boot application instances managed by a separate Auto Scaling Group. The application tier connects to a private Multi-AZ Amazon RDS MySQL database. Security groups restrict traffic between each tier, while health checks and Auto Scaling improve availability and scalability.”

## Important implementation note

This architecture is defined in Terraform. It must pass Terraform formatting, initialization, validation and plan checks, then be deployed and tested in AWS before it can be described as fully implemented or production-ready.

## AWS full forms

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
