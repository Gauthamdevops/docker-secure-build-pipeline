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
                sudo dnf install -y dnf-plugins-core
                sudo dnf config-manager --add-repo https://aquasecurity.github.io/trivy-repo/rpm/releases/trivy.repo
                sudo dnf install -y trivy

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

