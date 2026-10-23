pipeline {
    agent { label 'k8s-master' }

    parameters {
        booleanParam(name: 'FORCE_RELEASE', defaultValue: true, description: 'Bypass 25th of month check for immediate testing')
    }

    triggers {
        cron('0 0 25 * *')
        githubPush()
    }

    environment {
        DOCKER_IMAGE = "pratikbadshah03/analytics-website"
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                git branch: 'master', url: 'https://github.com/PratikBadshah03/website.git'
            }
        }
        stage('Build Custom Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            when {
                expression {
                    return (new Date().format("dd") == "25" || params.FORCE_RELEASE == true)
                }
            }
            steps {
                sh '''
                    kubectl apply -f k8s-deploy.yaml
                    kubectl rollout restart deployment/analytics-web-deploy
                '''
            }
        }
    }
}
