# Litecoin Daemon

This project is an example of how to build and deploy the litecoin daemon using Docker & Kubernetes.

The following assumptions have been made:
- You are using AWS and EKS
- You are using Jenkins
- You have configured Jenkins job with AWS credentials
- You have configured EKS with a role to allow storageClass provisioning


You will find the Jenkinsfile at the root of this repository, the Dockerfile in the build/ directory, and the Kubernetes YAML files in the deploy directory. 
