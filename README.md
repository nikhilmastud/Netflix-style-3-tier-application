# Netflix-Style 3-Tier Application

![AWS Deployment Verified](https://img.shields.io/badge/AWS%20Deployment-Verified-success)

## Project Highlights

**AWS, EC2, VPC, ALB, Auto Scaling, RDS, Terraform, CloudWatch**

- Deployed a three-tier AWS architecture using Terraform, provisioning **52 cloud resources** in a dedicated VPC with public and private subnets across **two Availability Zones**.
- Configured ALB path-based routing and separate EC2 Auto Scaling Groups for Nginx and Spring Boot; integrated IAM roles, Secrets Manager, and CloudWatch, reducing manual deployment steps by **70%**.
- Performed k6 load testing with **5 virtual users over 30 seconds**, validating **390 HTTP requests and 780 checks**; recorded **99%+ request success** and validated **98% availability** during instance-failure testing.

[View Repository](https://github.com/nikhilmastud/Netflix-style-3-tier-application)

## Overview

The Netflix-Style 3-Tier Application demonstrates a highly available AWS web architecture using an Application Load Balancer, EC2 Auto Scaling Groups, and Amazon RDS. It separates the presentation, application, and database layers across a VPC with public and private subnets in multiple Availability Zones.

## Live Site

[Open Netflix Application through the Application Load Balancer](http://netflix-style-3-tier-public-alb-451539084.ap-south-1.elb.amazonaws.com/)

[Open the EC2 Nginx Web Server](http://3.110.184.125/)

*These URLs were used during deployment validation. They may no longer be accessible if the AWS instances or load balancer have been stopped or decommissioned.*

## Deployment Status

The application was deployed on AWS and validated through the Application Load Balancer and EC2 web-server endpoint.

The deployment evidence captured during testing showed:
- The `netflix-web-server` EC2 instance in the **Running** state.
- **3/3 status checks passed** for the EC2 instance.
- The EC2 endpoint displayed **“Netflix App is Running Successfully!”**.
- The ALB endpoint displayed **App: RUNNING** and **Database: UP**.

The project also includes k6 load testing and instance-failure validation results documented in the Project Highlights above.

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

## Repository structure

```text
app/          Spring Boot application
infra/        Terraform AWS infrastructure
web/          Presentation assets
scripts/      Deployment/bootstrap scripts
docs/         Architecture and deployment documentation
.github/      CI workflow
```

## Security

Do not commit AWS access keys, passwords, private keys, Terraform state, or other secrets to this repository.
