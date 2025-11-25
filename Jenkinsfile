pipeline {
    agent any
    tools {
        jdk 'JDK-17.0.8.1+1-Tool'
        nodejs 'NodeJS-16.2.0-Tool'
    }
    environment {
        SCANNER_HOME = tool 'SonarQube-Scanner-Tool'
        DOCKER_IMAGE = 'nomanakram29/nodejs-app'
        IMAGE_TAG    = "${BUILD_NUMBER}"
    }
    stages {
        stage('WorkSpace CleanUp') {
            steps { cleanWs() }
        }

        stage('CheckOut from SCM') {
            steps {
                git branch: 'dev', 
                    credentialsId: 'Github-Token-for-Jenkins', 
                    url: 'https://github.com/noman-akram29/Node.js-Project-Pipeline.git'
            }
        }
        stage('Trivy FileSystem Scan') {
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
                        -Dsonar.projectKey=NodeJs-Project \
                        -Dsonar.projectName="Node.js Project" \
                        -Dsonar.sources=. \
                        -Dsonar.exclusions=node_modules/**,coverage/**,dist/**,test/** \
                        -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                        -Dsonar.sourceEncoding=UTF-8
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
        stage('OWASP Dependency-Check Scan') {
            steps {
                dependencyCheck additionalArguments: '''
                    --scan ./
                    --format ALL
                    --out dependency-check-report
                    --prettyPrint
                    --enableExperimental
                ''', odcInstallation: 'Dependency-Check-12.1.9-Tool'
                dependencyCheckPublisher pattern: 'dependency-check-report.html'
            }
        }
        stage('Build, Tag & Push Docker Image') {
            steps {
                script {
                    def app = docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                    docker.withRegistry('', 'Docker-Token-for-Jenkins') {
                        app.push()
                        app.push('latest')
                    }
                }
            }
        }

        stage('Trivy Docker Image Scan') {
            steps {
                sh """
                    trivy image --format table -o trivy-image-report.html ${DOCKER_IMAGE}:${IMAGE_TAG}
                    trivy image --exit-code 1 --no-progress --severity HIGH,CRITICAL ${DOCKER_IMAGE}:${IMAGE_TAG}
                """
            }
        }
        post {
            always {
                archiveArtifacts artifacts: '*-report.html', allowEmptyArchive: true
            }
        }
    }
}