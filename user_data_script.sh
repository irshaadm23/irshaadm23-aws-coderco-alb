#!/bin/bash

# Update packages
yum update -y

# Install Apache
yum install -y httpd

# Start Apache
systemctl start httpd
systemctl enable httpd

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create simple web page
cat <<EOF > /var/www/html/index.html
<html>
  <head>
    <title>ALB Demo</title>
  </head>
  <body>
    <h1>Application Load Balancer Demo</h1>
    <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
    <p><strong>Availability Zone:</strong> $AZ</p>
  </body>
</html>
EOF
