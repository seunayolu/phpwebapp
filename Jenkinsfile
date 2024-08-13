pipeline {
    agent any

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
    }
}