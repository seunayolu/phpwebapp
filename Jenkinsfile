pipeline {
    agent any
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
                    def dockerComposeCmd = 'docker compose -f docker-compose.yaml up --detach' 
                    sshagent(['ec-key']) {
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ec2-user@18.130.225.104:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@18.130.225.104 ${dockerComposeCmd}"
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