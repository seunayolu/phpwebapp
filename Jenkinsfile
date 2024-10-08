pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
        }
    }

    environment {
        DOCKER_CONFIG = '/tmp/.docker'  // Set to a directory with write access
        repoUri = "442042522885.dkr.ecr.us-west-2.amazonaws.com/webapp"
        repoRegistryUrl = "https://442042522885.dkr.ecr.us-west-2.amazonaws.com"
        registryCreds = 'ecr:us-west-2:awscreds'
        cluster = "phpwebapp"
        service = "webapptask-svc"
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
                    dockerImage = docker.build (repoUri + ":$BUILD_NUMBER")
                }
            }
        }

        stage('push image') {
            steps {
                script {
                    echo "Pushing Docker Image to ECR..."
                    docker.withRegistry(repoRegistryUrl, registryCreds) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        /*stage ('Deploy to ECS') {
            steps {
                script {
                    echo "Deploying Image to ECS..."
                    withAWS(credentials: 'awscreds', region: 'eu-west-2') {
                        sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
                    }
                }
            }
        }*/
    }
}