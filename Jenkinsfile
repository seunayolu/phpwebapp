pipeline {
    agent any

    environment {
        registryCreds = 'ecr:eu-west-2:awscreds'
        repoUri = "442042522885.dkr.ecr.eu-west-2.amazonaws.com/phpwebapp"
        repoRegistryUrl = "https://442042522885.dkr.ecr.eu-west-2.amazonaws.com"
        cluster = "webapp"
        service = "webapptask-svc"
    }

    stages {
        /*stage('Code Analysis') {
            environment {
                scannerHome = tool 'sonar-scanner-6'
            }
            steps {
                script {
                    echo "Code Analysis with SonarQube..."
                    withSonarQubeEnv('sonar-server') {
                        sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=phpwebapp \
                        -Dsonar.projectName=contactform \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=app/'''

                    }
                }
            }
        }*/
        stage ('Build_Docker_Image') {
            steps {
                script {
                    echo 'Build Docker Image from Dockerfile...'
                    dockerImage = docker.build (repoUri + ":$BUILD_NUMBER")
                }
            }
        }

        stage('Push_Image_to_ECR') {
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

        /*stage ('Deploy to ECS') {
            steps {
                script {
                    echo "Deploying Image to ECS..."
                    withAWS(credentials: 'awscreds', region: 'eu-west-2') {
                        sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
                    }
                }
            }
        }*/

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
            echo 'Notify Team members on Slack...'
        
            script {
                // Define the COLOR_MAP directly here
                def COLOR_MAP = [
                'SUCCESS': '#00FF00', // Green
                'FAILURE': '#FF0000', // Red
                'UNSTABLE': '#FFFF00', // Yellow
                'ABORTED': '#808080'  // Gray
                ]
            
                // Check if the COLOR_MAP and currentResult are set
                def buildResult = currentBuild.currentResult ?: 'UNKNOWN'
                def color = COLOR_MAP[buildResult] ?: '#FFFF00' // default to yellow if not found
            
                // Additional build information
                def buildDuration = currentBuild.durationString
                def triggeredBy = 'Unknown'
                if (currentBuild.getBuildCauses()) {
                    for (cause in currentBuild.getBuildCauses()) {
                        if (cause.userId) {
                            triggeredBy = cause.userId
                            break
                        }
                    }
                }
            
                // Slack message content
                def message = """
                    *${buildResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}
                    Triggered by: ${triggeredBy}
                    Duration: ${buildDuration}
                    More info at: ${env.BUILD_URL}
                """.stripIndent()
            
                // Send the Slack notification
                try {
                    slackSend channel: '#jenkins-build',
                          color: color,
                          message: message
                } catch (Exception e) {
                    echo "Failed to send Slack notification: ${e.message}"
                }
            }
        }
    }
}