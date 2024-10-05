pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
        }
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
    }
}