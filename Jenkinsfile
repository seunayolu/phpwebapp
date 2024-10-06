pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/workspace' // Mount Docker socket
        }
    }

    environment {
        DOCKER_CONFIG = '/tmp/.docker'  // Set to a directory with write access
        repoUri = "442042522885.dkr.ecr.us-west-2.amazonaws.com/webapp"
    }

    stages{
        stage ('docker test') {
            steps{
                script{
                    sh 'docker ps'
                    sh 'docker network create jenkins_docker || true'
                }
            }
        }

        stage ('build image') {
            steps{
                script{
                    echo 'Build Docker Image from Dockerfile...'
                    sh 'mkdir -p /tmp/.docker'  // Ensure the directory exists
                    sh 'ls -l /workspace'
                    sh 'cd /workspace'
                    dockerImage = docker.build (repoUri + ":$BUILD_NUMBER", "./multistage/")
                }
            }
        }
    }
}