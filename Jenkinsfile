pipeline {
    agent any

    environment {
        
        EC2_IP = '172.20.4.132'
    }

    stages {
        stage ('Build Image') {
            steps {
                echo 'Build Docker Image from Dockerfile...'
                sh 'docker buildx build -t oluwaseuna/phpwebapp .'
            }
        }

        stage('push_image') {
            steps {
                script {
                    echo "Pushing Docker Image to Docker Hub Repo..."
                    withCredentials([usernamePassword(credentialsId: 'Docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh 'docker push oluwaseuna/phpwebapp'
                    }       
                }
            }
        }

        stage('DeploytoEC2') {
            steps {
                script {
                    echo "Deploying the application to EC2..."
                    def dockerComposeCmd = 'docker compose -f docker-compose.yml up -d' 
                    sshagent(['EC2']) {
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@${EC2_IP}:/home/ubuntu"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} ${dockerComposeCmd}"
                    }
                }
            }
        }

        stage('Prune Docker System') {
            steps {
                script {
                    echo 'Pruning Docker System'
                    sh 'docker system prune -af'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker system prune -af'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}