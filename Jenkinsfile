pipeline {
    agent any
    tools {
        jdk 'JDK-17.0.9+9'
        maven 'Maven-3.9.11'
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