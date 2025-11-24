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
        stage('Workspace Cleanup') {
            steps { cleanWs() }
        }

        stage('Checkout from SCM') {
            steps {
                git branch: 'main', credentialsId: 'Github-Token-for-Jenkins', url: 'https://github.com/noman-akram29/Node.js-Project-Pipeline.git'
            }
        }
        
    }
}