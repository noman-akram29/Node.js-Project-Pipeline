pipeline {
    agent any
    tools {
        jdk 'JDK-17.0.8.1+1-Tool'
        nodejs 'NodeJS-16.2.0-Tool'
    }
    environment {
        SCANNER_HOME = tool 'SonarQube-Scanner-Tool'
    }
    stages {
        stage('WorkSpace CleanUp') {
            steps { cleanWs() }
        }

        stage('CheckOut from SCM') {
            steps {
                git branch: 'dev', credentialsId: 'Github-Token-for-Jenkins', url: 'https://github.com/noman-akram29/Node.js-Project-Pipeline.git'
            }
        }
        stage('Trivy Filesystem Scan') {
            steps {
                sh '''
                    trivy fs --exit-code 0 --no-progress --format table -o trivy-fs-report.html .
                    trivy fs --exit-code 1 --no-progress --severity HIGH,CRITICAL .
                '''
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=NodeJs-Project \
                        -Dsonar.projectKey=NodeJs-Project \
                        -Dsonar.java.binaries=.
                    '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true, credentialsId: 'SonarQube-Token-for-Jenkins'
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
    }
}