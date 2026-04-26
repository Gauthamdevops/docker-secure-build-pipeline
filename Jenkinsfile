pipeline {
    agent any
    
    environment {
        IMAGE_NAME = 'gauthamdev/dockersecurebuild'
        COMMIT_SHA = "${env.GIT_COMMIT}"
    }
    
    stages {
        stage('Build Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$COMMIT_SHA .
                docker tag $IMAGE_NAME:$COMMIT_SHA $IMAGE_NAME:latest
                '''
            }
        }
        
        stage('Push the Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE_NAME:$COMMIT_SHA
                    docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }
        
        stage('Install Trivy') {
            steps {
                sh '''
                # Install Trivy (Amazon Linux 2023)
                LATEST=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest \
                  | grep browser_download_url \
                  | grep rpm \
                  | cut -d '"' -f 4)

                wget $LATEST
                sudo dnf install -y ./$(basename $LATEST)
                '''
            }
        }
        
        stage('Security Scan') {
            steps {
                sh '''
                trivy image --exit-code 1 --severity HIGH,CRITICAL $IMAGE_NAME:$COMMIT_SHA
                '''
            }
        }
    }
}

