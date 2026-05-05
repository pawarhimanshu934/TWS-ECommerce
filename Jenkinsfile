pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = hiimanshupawar/ecommerce-app 
        DOCKER_MIGRATION_IMAGE_NAME = hiimanshupawar/ecommerce-migration
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
    }
}
