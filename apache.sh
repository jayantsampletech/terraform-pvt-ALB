#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package list..."
sudo apt update -y

echo "Installing Apache2..."
sudo apt install -y apache2

echo "Enabling Apache2 to start on boot..."
sudo systemctl enable apache2

echo "Starting Apache2 service..."
sudo systemctl start apache2

echo "Creating custom Apache2 landing page..."
cat <<EOF | sudo tee /var/www/html/index.html > /dev/null
<!DOCTYPE html>
<html>
<head>
    <title>Private EC2 Apache2</title>
</head>
<body>
    <h1>Hello, welcome to private EC2 Apache2</h1>
</body>
</html>
sleep 120
EOF