# Netflix-Style 3-Tier AWS Architecture — Low-Cost Lab

## Request flow

Users -> Public Application Load Balancer -> (default route) Nginx Web EC2 -> static frontend.
Users -> Public Application Load Balancer (/api/* path rule) -> Spring Boot EC2 -> private Amazon RDS MySQL.

## Network placement

- Public subnets in two Availability Zones: internet-facing ALB and one NAT Gateway in AZ A.
- Private web subnets in two Availability Zones: Nginx EC2 Auto Scaling Group (one baseline instance).
- Private application subnets in two Availability Zones: Spring Boot EC2 Auto Scaling Group (one baseline instance).
- Private database subnets in two Availability Zones: Single-AZ Amazon RDS MySQL.
- Private subnet route tables share the NAT Gateway in AZ A to reduce fixed cost; this introduces a single-AZ egress dependency and cross-AZ data charges for workloads in AZ B.

## Tier-to-tier security

- Internet -> public ALB: TCP 80 only (HTTP lab endpoint; no TLS certificate configured).
- Public ALB -> web instances: TCP 80.
- Public ALB path rule /api and /api/* -> application instances: TCP 8080.
- Application instances -> RDS: TCP 3306.
- RDS is not publicly accessible.

## Cost and availability trade-offs

- One public ALB; internal ALB removed.
- One NAT Gateway shared by private subnets.
- Web and application ASGs each start at one instance and can scale to two across two AZs.
- RDS is Single-AZ for lab cost control; database failover is not provided.
- This is a low-cost learning deployment, not the original full HA/production architecture.

## Monitoring

CloudWatch alarms cover web/app CPU, RDS CPU, public ALB 5xx and RDS free storage. No SNS email notifications are configured.

## Interview explanation

"I built a cost-optimized three-tier AWS lab. An internet-facing ALB serves the Nginx presentation tier by default and routes /api requests to a private Spring Boot application tier using path-based routing. The application connects to a private Single-AZ RDS MySQL database. Security groups restrict inbound access to the required tier-to-tier ports. EC2 Auto Scaling Groups can scale from one to two instances, while CloudWatch alarms monitor key service metrics. I deliberately traded Multi-AZ database failover and a dedicated internal ALB for lower lab cost."

## Important limitations

- HTTP only; add ACM and a domain before production use.
- One NAT Gateway is a single point of egress failure.
- Single-AZ RDS has no automatic AZ failover.
- Do not leave NAT Gateway, ALB, RDS or EC2 resources running when the lab is idle.
