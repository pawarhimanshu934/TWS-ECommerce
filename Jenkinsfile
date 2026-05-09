@Library("SharedLib") _

pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "hiimanshupawar/easyshop"
        DOCKER_MIGRATION_IMAGE_NAME = "hiimanshupawar/easyshop-migration"
        IMAGE_TAG = "${BUILD_NUMBER}"
        

    }

    stages {
        stage("Clean Workspace") {
            steps {
                cleanWs()
            }
        }  

        stage("Clone Code") {
            steps {
                script{
                    clone("https://github.com/pawarhimanshu934/TWS-ECommerce.git", "main")
                }
            }
        }

        stage("Build") {
            parallel{
                stage("App-build"){
                    steps{
                        script{
                            buildDockerImage( 
                                image_name : env.DOCKER_IMAGE_NAME,
                                image_tag : env.IMAGE_TAG,
                                dockerfile : "Dockerfile",
                                context : "."
                            )
                        }
                    }
                }
                stage("DB-migration"){
                    steps{
                        script{
                            buildDockerImage(
                                image_name : env.DOCKER_MIGRATION_IMAGE_NAME,
                                image_tag : env.IMAGE_TAG,
                                dockerfile : "scripts/Dockerfile.migration",
                                context : "."
                            )
                        }
                    }
                }
            }
        }

        stage("Unit-Tests"){
            steps{
                sh "echo 'Running Unit-Tests'"
            }
        }

        stage("Security-Scan with Trivy"){
            steps{
                sh "echo 'Running Security-Scan with Trivy'"

                script{
                    echo "Running Trivy Scan for E-Commerce build image"

                    def appVulns = trivyScan(
                                image_name : env.DOCKER_IMAGE_NAME,
                                image_tag : env.IMAGE_TAG,
                                severity : 'HIGH,CRITICAL'
                                )    
                    
                    echo "App Vulnerabilities: ${appVulns}"

                    echo "Running Trivy Scan for Migration build image"

                    def migrationVulns = trivyScan(
                                    image_name : env.DOCKER_MIGRATION_IMAGE_NAME,
                                    image_tag : env.IMAGE_TAG,
                                    severity : 'HIGH,CRITICAL'
                                    )
                    echo "Migration Vulnerabilities: ${migrationVulns}"
                }

            }
        }

        
        stage("Push E-Commerce Image"){
            steps{
                
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-credentials',
                    passwordVariable: 'DOCKER_PASSWORD',
                    usernameVariable: 'DOCKER_USERNAME'
                )]) {

                sh """
                echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                """
                }

                script{
                    pushDockerImage(
                        image_name : env.DOCKER_IMAGE_NAME,
                        image_tag : env.IMAGE_TAG
                    )
                }
            }
        }

        stage("Push DB Migration Image"){
            steps{
                script{
                    pushDockerImage(
                        image_name : env.DOCKER_MIGRATION_IMAGE_NAME,
                        image_tag : env.IMAGE_TAG
                    )
                }
            }
        }
            
        stage("Update Kubernetes Manifests"){
            steps{
                sh "echo 'Kubernetes manifests are updated.....'"
            }
        }    
    }

    post {
        always {
            cleanWs()

            sh 'docker system prune -af || true'
            sh 'docker builder prune -af || true'
        }
    }
}

