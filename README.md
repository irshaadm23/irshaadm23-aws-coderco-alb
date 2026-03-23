Application Load Balancer with Auto Scaling on AWS
Overview

This project implements a production-style AWS architecture where an Application Load Balancer (ALB) distributes traffic across multiple EC2 instances running across two Availability Zones in eu-west-2.

The setup focuses on:

multi-AZ availability
secure ingress through the load balancer
health checks and traffic distribution
automatic instance replacement through Auto Scaling
HTTPS termination using AWS Certificate Manager (ACM)

DNS was managed through Cloudflare, which pointed the domain to the ALB.

Architecture Summary
Internet-facing Application Load Balancer deployed across two subnets in:
eu-west-2a
eu-west-2b
Multiple EC2 instances registered in a target group
Target Group configured on HTTP with health checks on /
Auto Scaling Group used to maintain desired instance capacity
HTTPS enabled on the ALB using an ACM certificate
Cloudflare DNS configured to point the domain to the ALB DNS name

Design
Ingress: Public traffic enters through the ALB
Availability: Resources are distributed across multiple Availability Zones
Scaling: Auto Scaling Group helps maintain service capacity
TLS termination: HTTPS is terminated at the ALB using ACM
DNS: Cloudflare is used for external DNS resolution
Security

The ALB security group allows:
HTTP (80)
HTTPS (443)
The EC2 security group allows:
HTTP (80) for application traffic

During setup, EC2 instances were temporarily assigned public IPs so the application and user data provisioning could be tested directly. This made it possible to verify that the web server was correctly installed and serving content before routing traffic through the ALB.

In a stricter production design, backend EC2 instances would not be directly reachable from the internet and would instead be limited to ALB-only ingress.

Traffic Flow

User → Cloudflare DNS → ALB (HTTP/HTTPS) → Target Group → EC2 instances

Implementation
EC2 instances were configured using user data
The application served instance-specific information so traffic distribution could be observed during testing
An Application Load Balancer was created with:
HTTP listener on port 80
HTTPS listener on port 443
A target group was attached to the ALB
Health checks were configured on /
An Auto Scaling Group was configured to maintain backend instance capacity
An ACM certificate was issued and attached to the HTTPS listener
Domain validation for ACM was completed using DNS records in Cloudflare
Validation

The following checks were performed to confirm the setup worked as expected:

Verified the application was accessible through the ALB DNS name
Verified HTTPS was working with the attached ACM certificate
Confirmed the ALB had both HTTP and HTTPS listeners
Confirmed the target group showed healthy registered targets
Confirmed responses displayed instance-specific details, showing requests were being routed to backend instances
Terminated a backend EC2 instance to test resilience
Confirmed the application remained available through the ALB while one instance was removed
Confirmed the Auto Scaling Group launched a replacement instance to restore desired capacity
Failure-Mode / Self-Healing Test

A backend EC2 instance was deliberately terminated to test high availability and recovery behaviour.

This demonstrated that:

the ALB continued routing traffic to the remaining healthy target
the service remained available during instance loss
the Auto Scaling Group automatically launched a replacement instance
desired capacity was restored without manual intervention

This validated the architecture as a self-healing load-balanced setup rather than a single-instance deployment.


Notes

Although the final traffic path was tested through the ALB, public IPs were temporarily useful during setup to validate EC2 user data and confirm the web server was working correctly.

For a more production-hardened version of this project, the backend instances would be moved fully behind the ALB with tighter inbound restrictions and no direct public exposure.
