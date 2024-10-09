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
                    sh 'mkdir -p /tmp/.docker'  // Ensure the directory exists
                    dockerImage = docker.build(repoUri + ":$BUILD_NUMBER")
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
        // Purge the Jenkins Server
        stage('Prune Docker System') {
            steps {
                script {
                    echo 'Pruning Docker System'
                    sh 'docker system prune -af --volumes'
                }
            }
        }

        // Use a pre-built AWS CLI image for the ECS deployment stage
        stage('Deploy to ECS') {
            agent {
                docker {
                    image 'amazon/aws-cli:latest'  // Use a pre-built AWS CLI Docker image
                }
            }
            steps {
                script {
                    echo "Deploying Image to ECS..."
                    withAWS(credentials: 'awscreds', region: 'us-west-2') {
                        sh 'aws sts get-caller-identity'
                    }
                }
            }
        }
    }
}
