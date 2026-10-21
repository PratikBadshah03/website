pipeline {
    agent any

    stages {
        stage('Job1 : build') {
            steps {
                echo 'Building Docker image'

                sh '''
                    docker build -t abode-webapp:latest .
                '''
            }
        }

        stage('Job2 : test') {
            steps {
                echo 'Deploying to test environment'

                sh '''
                    docker rm -f abode-test || true

                    docker run -d \
                        --name abode-test \
                        -p 8081:80 \
                        abode-webapp:latest

                    sleep 3

                    curl -f http://localhost:8081/
                '''
            }
        }

        stage('Job3 : prod') {
            when {
                branch 'master'
            }

            steps {
                echo 'Deploying to production'

                sh '''
                    docker rm -f abode-prod || true

                    docker run -d \
                        --name abode-prod \
                        -p 80:80 \
                        abode-webapp:latest

                    sleep 3

                    curl -f http://localhost:80/
                '''
            }
        }
    }
}
