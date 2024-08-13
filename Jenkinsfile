pipeline {
    agent {
        dockerfile {
            label 'oluwaseuna/webapp'
            registryUrl ' https://hub.docker.com/'
            registryCredentialsId 'Docker-hub-repo'
        }
    }

    stages {
        stage {
            steps {
                echo 'Print docker images...'
                sh 'docker images'
            }
        }
    }
}