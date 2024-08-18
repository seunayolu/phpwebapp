pipeline {
    agent any

    stages {
        
        stage ('fetch code') {
            steps {
                echo 'Fetch code from Github Repo'
                git branch: 'contactform', url: 'https://github.com/seunayolu/phpwebapp.git'
            }
        }
        
        stage('Code Analysis') {
            environment {
                scannerHome = tool 'sonar-scanner-6'
            }
            steps {
                script {
                    echo "Code Analysis with SonarQube..."
                    withSonarQubeEnv('sonar-server') {
                        sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=phpwebapp \
                        -Dsonar.projectName=webapp \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=app/'''

                    }
                }
            }
        }
        /*stage ('Build Image') {
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

        stage('Prune Docker System') {
            steps {
                script {
                    echo 'Pruning Docker System'
                    sh 'docker system prune -af'
                }
            }
        }*/
    }
}