pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
        }
    }

    environment {
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
                    dockerImage = docker.build (repoUri + ":$BUILD_NUMBER", "./multistage/")
                }
            }
        }
    }
}