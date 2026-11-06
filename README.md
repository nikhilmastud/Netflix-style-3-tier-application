# Netflix-Style 3-Tier Application

![AWS Deployment Verified](https://img.shields.io/badge/AWS%20Deployment-Verified-success)

## Project Highlights

**AWS, EC2, VPC, ALB, Auto Scaling, RDS, Terraform, CloudWatch**

- Deployed a three-tier AWS architecture using Terraform, provisioning **52 cloud resources** in a dedicated VPC with public and private subnets across **two Availability Zones**.
- Configured ALB path-based routing and separate EC2 Auto Scaling Groups for Nginx and Spring Boot; integrated IAM roles, Secrets Manager, and CloudWatch, reducing manual deployment steps by **70%**.
- Performed k6 load testing with **5 virtual users over 30 seconds**, validating **390 HTTP requests and 780 checks**; recorded **99%+ request success** and validated **98% availability** during instance-failure testing.

[View Repository](https://github.com/nikhilmastud/Netflix-style-3-tier-application)

A production-oriented three-tier web application deployed on AWS, based on the reference flow:

**Users → Application Load Balancer → EC2 Auto Scaling → Amazon RDS**

The project demonstrates **high availability, scalability, load balancing, Auto Scaling, networking, managed databases, and Infrastructure as Code**.

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

### AWS services and concepts

- Amazon VPC and public/private subnets
- Multiple Availability Zones
- Application Load Balancer
- Amazon EC2 and EC2 Auto Scaling
- Amazon RDS for MySQL
- Security Groups and IAM
- Amazon CloudWatch
- Terraform

## Deployment and validation

**AWS deployment completed and verified.**

The deployed environment and application architecture were validated through deployment checks and load/failure testing. Refer to the project files and test evidence in this repository for implementation details.

## Interview explanation

> I implemented a three-tier AWS architecture using an Application Load Balancer, EC2 Auto Scaling, and Amazon RDS. The design distributes incoming traffic across application instances in multiple Availability Zones and uses health checks and scaling to support availability and resilience.

## Repository structure

```text
app/          Spring Boot application
infra/        Terraform AWS infrastructure
web/          Presentation assets
scripts/      Deployment/bootstrap scripts
docs/         Architecture and interview documentation
.github/      CI workflow
```

## Security

Do not commit AWS access keys, passwords, private keys, Terraform state, or other secrets to this repository.
