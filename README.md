# Litecoin Daemon

This project is an example of how to build and deploy the litecoin daemon using Docker & Kubernetes.

The following assumptions have been made:
- You are using AWS and EKS
- You are using Jenkins
- You have configured Jenkins job with AWS credentials
- You have configured EKS with a role to allow storageClass provisioning


You will find the Jenkinsfile at the root of this repository, the Dockerfile in the build/ directory, and the Kubernetes YAML files in the deploy directory. 




### Jenkinsfile

The Jenkinsfile is located in the root of the repository and assumes that you have configured this project with AWS access key/secret, the EKS cluster name/region, and your dockerHub credentials. 

The Jenkins pipeline should pull down the latest version of the repository, build the docker container, push the container to dockerhub, and then deploy the container to kubernetes before cleaning up afterwards.


### Build

The build folder contains the Dockerfile for Litecoin Daemon, which can be built as-is in any environment.

The container runs as the litecoin user and defaults to daemon mode.

Both Testnet and Mainnet ports are exposed. 

Some of the code was inspired by the following project. I did notice that they were not verifying the sha256sum of the downloaded package, submitted a pull request to the project with my solution.

[https://github.com/uphold/docker-litecoin-core/pull/23](https://github.com/uphold/docker-litecoin-core/pull/23)


### Delpoy

The deploy folder contains the Kubernetes YAML files to deploy a statefulset to your cluster.

This assumes you have an EKS cluster with permission to provision EBS storage. If not, this can be modified to use local storage, or another provider. 


### Processing

The processing folder contains examples of text based manipulation problems and solutions using standard linux tooling, as well as examples using various languages.




### Missing

A deployent in Nomad was not created as I do not currently have any experience with Nomad.
