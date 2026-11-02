# Netflix-Style 3-Tier Application

A Terraform-based AWS deployment demonstrating a three-tier application using an Nginx presentation tier, a Spring Boot application tier, and Amazon RDS for MySQL.

## Live deployment proof

**Deployment result:** Terraform apply completed successfully.

- Terraform result: **52 resources added, 0 changed, 0 destroyed**
- VPC: vpc-0ae1c2e3b4eb8f990
- Application Load Balancer: netflix-style-3-tier-public-alb
- Web Auto Scaling Group: netflix-style-3-tier-web-asg
- Application Auto Scaling Group: netflix-style-3-tier-asg
- RDS: MySQL, Multi-AZ enabled
- Browser verification reported: **App: RUNNING | Database: UP**

### Live ALB endpoint (temporary)

[Open the deployed application](http://netflix-style-3-tier-public-alb-451539084.ap-south-1.elb.amazonaws.com/)

> The endpoint uses HTTP, not HTTPS. It will stop working after the temporary AWS infrastructure is destroyed. The browser may show a “Not secure” warning because an HTTPS listener and certificate were not configured.

### Deployment screenshot

![Application health proof](Screenshot%20(111).png)

The screenshot is committed in the repository root as `Screenshot (111).png`.

## Actual deployed architecture

~~~text
                         USERS
                           |
                           v
                Internet-facing ALB
                     HTTP :80
                    /         \\
             default path    /api and /api/*
                  |                |
                  v                v
             Web Target       App Target
             Nginx EC2        Spring Boot EC2
                  |                |
             HTML / UI             v
                              Amazon RDS
                              MySQL Multi-AZ
~~~

**Important routing detail:** The ALB sends normal website requests to the Nginx web target group. Requests matching /api and /api/* are routed directly from the ALB to the application target group. API traffic does **not** pass through Nginx in the current implementation.

## AWS resources and design

- Dedicated VPC: 10.20.0.0/16
- Two Availability Zones
- Public, Web, Application, and Database subnet tiers
- Internet Gateway and a single NAT Gateway
- Internet-facing Application Load Balancer
- Separate Web and Application EC2 Auto Scaling Groups
- Nginx presentation tier
- Spring Boot application tier
- Amazon RDS for MySQL with Multi-AZ enabled
- Tier-based Security Groups
- IAM instance role and Secrets Manager access for the application
- CloudWatch alarms and Auto Scaling policies
- Terraform Infrastructure as Code

The Web and Application subnet groups span two Availability Zones. Each Auto Scaling Group was configured with desired capacity 1 and maximum capacity 2. The RDS database is configured for Multi-AZ.

## Verification status

| Check | Result |
|---|---|
| Terraform deployment | Passed — 52 resources created |
| ALB website access | Passed — page displayed |
| Nginx presentation tier | Reported working |
| Application health | Reported RUNNING |
| Database health | Reported UP |
| HTTPS | Not configured |
| Route 53 custom domain | Not configured |
| Separate API and target-health checks | To be documented after verification |

The application and database status above is based on the browser verification performed during this deployment. It is not a claim of a long-duration load or failover test.

## Terraform deployment

From the infra/ directory:

~~~bash
terraform init
terraform plan -out=new-tfplan
terraform apply "new-tfplan"
~~~

The successful apply in this deployment reported:

~~~text
Apply complete! Resources: 52 added, 0 changed, 0 destroyed.
~~~

## Cleanup and cost control

This was a temporary live deployment for validation and portfolio evidence. After collecting screenshots and completing the remaining checks, destroy only the **new Terraform-managed stack**:

~~~bash
terraform destroy
~~~

Review the destroy plan before confirming. Preserve the pre-existing AWS VPC, stopped EC2 instances, EBS volumes, and the earlier database backup snapshot. A final RDS snapshot may remain and incur storage charges. Also check for separately existing resources, such as the older NAT Gateway, which are not managed by this Terraform state.

## Repository structure

~~~text
app/          Spring Boot application
infra/        Terraform AWS infrastructure
web/          Presentation assets
scripts/      Deployment/bootstrap scripts
docs/         Architecture and deployment documentation
.github/      CI workflow
~~~

## Interview explanation

I deployed a three-tier application on AWS using an internet-facing Application Load Balancer, Nginx on EC2 for the presentation tier, a Spring Boot application tier, and Amazon RDS for MySQL with Multi-AZ enabled. Terraform provisions the VPC, subnet tiers, security groups, Auto Scaling Groups, load balancing, IAM permissions, and CloudWatch alarms. The current ALB routes website traffic to Nginx and API paths directly to the application target group.

## Security

Do not commit AWS access keys, passwords, private keys, Terraform state, or other secrets to this repository.