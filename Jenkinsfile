pipeline {
    agent {
        docker {
            image 'docker'
            args '--privileged'
        }
    }

    environment {
        EC2_IP = '35.179.136.128'
    }
    stages {
        stage('build_image') {
            steps {
                script {
                    echo "Build Docker Image with Dockerfile..."
                    sh 'docker build -t oluwaseuna/phpwebapp .'
                }
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
        stage('push') {
            steps {
                script {
                    echo "Deploying the application to EC2..."
                    def dockerComposeCmd = 'docker compose -f docker-compose.yml up -d' 
                    sshagent(['ec-key']) {
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@${EC2_IP}:/home/ubuntu"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} ${dockerComposeCmd}"
                    }
                }
            }
        }
        /*stage('deploy') {
            steps {
                script {
                    echo "..."
                    gv.deployImage()
                }
            }
        }*/
    }   
}