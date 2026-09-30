# Netflix-Style 3-Tier Application

A production-oriented three-tier web application architecture built on AWS, based on the reference flow:

**Users → Application Load Balancer → multiple EC2 instances → Amazon RDS**

The project demonstrates architecture thinking around **high availability, scalability, load balancing, Auto Scaling, networking, and managed databases**.

## Architecture

```text
                         USERS
                           |
                           v
              +------------------------+
              | Application Load       |
              | Balancer (ALB)         |
              +-----------+------------+
                          |
                +---------+---------+
                |                   |
                v                   v
             EC2 #1              EC2 #2
              AZ-1                AZ-2
                |                   |
                +---------+---------+
                          |
                          v
                    Amazon RDS
                     MySQL
```

### Three logical tiers

1. **Presentation layer** — user-facing application.
2. **Application layer** — request and business processing on EC2.
3. **Database layer** — persistent data in Amazon RDS MySQL.

### AWS concepts

- Amazon VPC
- Availability Zones
- Application Load Balancer
- Amazon EC2
- EC2 Auto Scaling Group
- Amazon RDS for MySQL
- Security Groups
- IAM
- CloudWatch
- Terraform

## Production-ready goals

- Multiple EC2 instances across Availability Zones
- ALB health checks and traffic distribution
- Auto Scaling for traffic spikes
- Private database access
- Tier-based security groups
- Highly available network design
- Infrastructure as Code with Terraform

## Deployment status

**Not deployed yet.** No AWS resources have been created by this repository at this stage.

Deployment will be performed only after Terraform validation and a final cost/safety review.

## Interview explanation

> I designed a highly available three-tier web application using Application Load Balancer, EC2, RDS, and Auto Scaling Group. The architecture distributes traffic efficiently across multiple EC2 instances running across Availability Zones and maintains application availability during instance failure.

## Repository structure

```text
app/          Spring Boot application
infra/        Terraform AWS infrastructure
web/          Presentation assets
scripts/      Deployment/bootstrap scripts
docs/         Architecture and interview documentation
.github/      CI workflow
```

## Important

Do not commit AWS access keys, passwords, private keys, Terraform state, or other secrets to this repository.
