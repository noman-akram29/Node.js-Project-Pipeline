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
        stage('OWASP FileSystem Scan') {
            steps {
                sh "dependency-check --scan ./ --disableYarnAudit --disableNodeAudit"
                sh "ls -l **/dependency-check-report.xml"
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Build & Tag Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'Docker-Token-for-Jenkins') {
                        def image = docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}", ".")
                        image.tag("latest")
                    }
                }
            }
        }
        stage('Trivy Docker Image Scan') {
            steps {
                sh """
                    trivy image --exit-code 0 --format table -o trivy-image-report.html ${DOCKER_IMAGE}:${IMAGE_TAG}
                    trivy image --exit-code 1 --no-progress --severity CRITICAL ${DOCKER_IMAGE}:${IMAGE_TAG}
                """
            }
        }
    }
}