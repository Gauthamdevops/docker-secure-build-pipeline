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
                sudo dnf install -y wget
                wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.50.2_Linux-64bit.rpm
                sudo dnf install -y ./trivy_0.50.2_Linux-64bit.rpm

                # Verify
                trivy --version
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

