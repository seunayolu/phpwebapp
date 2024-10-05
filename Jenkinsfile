pipeline {
    agent {
        docker {
            image 'docker:latest'
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