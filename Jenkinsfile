pipeline {
    agent any

    stages {
        stage ('Build Image') {
            steps {
                echo 'Build Docker Image from Dockerfile...'
                sh 'docker buildx build -t oluwaseuna/phpwebapp .'
            }
        }
    }
}