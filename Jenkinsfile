/*
 * Pipeline to checkout git repo, build the Dockerfile, push to Dockerhub, and deploy to Kubernetes
 * Assumptions: This project is configured in Jenkins with variables set for access id, token, and EKS name.
 * - dh
 */

pipeline {

  environment {
    // The DockerHub repo and credential name.
    REGISTRY = 'davidhoude/litecoind'
    REGISTRY_CREDS = 'dockerhub'
    DOCKER_IMAGE = ''

    // AWS ENV VARs configured in Jenkins per-job, used to point to the correct cluster,
    // region, and uses per-job access keys instead of global Jenkins permissions.
    EKS_REGION=${VAR_EKS_REGION}
    EKS_CLUSTER=${VAR_EKS_CLUSTER}
    AWS_ACCESS_KEY_ID=${VAR_AWS_ACCESS_KEY_ID}
    AWS_SECRET_ACCESS_KEY_ID=credentials('davidhoude-litecoin-eks-access-secret')
  }

  agent any

  stages {


    // Clone the repo
    stage('Git Clone') {
      when {
        anyOf {
          branch 'dev'
        }
      }
      steps {
        git 'https://github.com/davidhoude/homework.git'
      }
    }


    // Build docker container using ./build/Dockerfile
    stage('Docker Build') {
      when {
        anyOf {
          branch 'dev'
        }
      }
      steps{
        dir("build") {
          script {
            DOCKER_IMAGE = docker.build REGISTRY + ":$BUILD_NUMBER"
          }
        }
      }
    }


    // Run unit tests - placeholder
    stage('Run Tests') {
      when {
        anyOf {
          branch 'dev'
        }
      }
      steps{
        sh "echo placeholder"
      }
    }


    // Static code scan - placeholder
    stage('Run Tests') {
      when {
        anyOf {
          branch 'dev'
        }
      }
      steps{
        sh "echo placeholder"
      }
    }


    // Push docker container to DockerHub
    stage('Docker Push') {
      when {
        anyOf {
          branch 'dev'
        }
      }
      steps{
        script {
          docker.withRegistry('', REGISTRY_CREDS) {
            DOCKER_IMAGE.push()
          }
        }
      }
    }


    // Download KUBECONF into workspace using AWS Key/Secret ENV VARS and AWSCLI from the master node (no workers)
    stage('Kube Config') {
      when {
        anyOf {
          branch 'dev'
        }
      }
      node('master') {
        sh '''
          aws eks --region ${EKS_REGION} update-kubeconfig --name ${EKS_CLUSTER}
        '''
      }
    }


    // Deploy docker container to EKS from master node (no workers)
    stage('Kube Deploy') {
      when {
        anyOf {
          branch 'dev'
        }
      }
      node('master') {
        sh '''
          echo "Deploying Stateful Set"
          kubectl config use-context ${EKS_CLUSTER}
          sed -i "s/litecoin:latest/litecoin:${BUILD_NUMBER}/g" deploy/litecoin.statefulset.yaml
          kubectl apply -f deploy/litecoin.statefulset.yaml
        '''
      }
    }


    // Delete the docker image and the kube context from the jenkins workspace
    post('Cleanup') {
      steps{
        sh "docker rmi ${REGISTRY}:${BUILD_NUMBER}"
        sh "kubectl config unset contexts.${EKS_CLUSTER}"
      }
    }
  }
}
