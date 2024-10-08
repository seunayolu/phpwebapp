pipeline {
    agent {
        docker {
            image 'docker:latest'  // Use Docker agent for build and push stages
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_CONFIG = '/tmp/.docker'  // Set to a directory with write access
        repoUri = "442042522885.dkr.ecr.us-west-2.amazonaws.com/webapp"
        repoRegistryUrl = "https://442042522885.dkr.ecr.us-west-2.amazonaws.com"
        registryCreds = 'ecr:us-west-2:awscreds'
        cluster = "phpwebapp"
        service = "webapptask-svc"
        region = 'us-west-2'
    }

    stages {
        stage('Docker Test') {
            steps {
                script {
                    sh 'docker ps'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image from Dockerfile...'
                    dockerImage = docker.build(repoUri + ":$BUILD_NUMBER", ".")
                }
            }
        }

        stage('Push Docker Image to ECR') {
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

        // Use a pre-built AWS CLI image for the ECS deployment stage
        stage('Deploy to ECS') {
            agent {
                docker {
                    image 'amazon/aws-cli'  // Use a pre-built AWS CLI Docker image
                }
            }
            steps {
                script {
                    echo "Deploying Image to ECS..."
                    withAWS(credentials: 'awscreds', region: "${region}") {
                        sh "aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment"
                    }
                }
            }
        }
    }
}
