pipeline {
    agent any
    
    environment {
        IMAGE_NAME = 'gauthamdev/app'
        COMMIT_SHA = "${env.GIT_COMMIT}"
    }
    
    stages {
        stage('Build Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:COMMIT_SHA .
                docker tag $IMAGE_NAME:COMMIT_SHA $IMAGE_NAME:latest
                '''
            }
        }
        
        stage ('Push the Image') {
            steps {
                withCredentials([userNamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME:$COMMIT_SHA
                    docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }
    }
}
