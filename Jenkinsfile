pipeline {
    agent none
    environment {
        DOCKER_CONFIG = '/tmp/.docker'
        repoUri = "442042522885.dkr.ecr.us-west-2.amazonaws.com/webapp"
        repoRegistryUrl = "https://442042522885.dkr.ecr.us-west-2.amazonaws.com"
        registryCreds = 'ecr:us-west-2:awscreds'
        cluster = "phpwebapp"
        service = "webapptask-svc"
        region = 'us-west-2'
    }
    
    options {
        skipStagesAfterUnstable()  // Skip subsequent stages if any stage becomes unstable
    }

    stages {
        stage('Build & Push Docker Image') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
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
                            sh 'mkdir -p /tmp/.docker'
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
            }
        }
        stage('Prune Docker System') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    echo 'Pruning Docker System'
                    sh 'docker system prune -af --volumes'
                }
            }
        }
        stage('Deploy to ECS') {
            agent {
                docker {
                    image 'amazon/aws-cli:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --entrypoint=""'
                }
            }
            steps {
                script {
                    echo "Deploying Image to ECS..."
                    withAWS(credentials: 'awscreds', region: "${region}") {
                        sh 'aws sts get-caller-identity'
                    }
                }
            }
        }
    }
}