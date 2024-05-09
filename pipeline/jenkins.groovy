pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Select OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Select ARCH')
    }
    environment {
        GITHUB_TOKEN=credentials('Jenkins')
        REPO = 'https://github.com/andrefanatic/kbot.git'
        BRANCH = 'main'
    }

    stages {

        stage('clone') {
            steps {
                echo 'Clone Repository'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }

        stage('test') {
            steps {
                echo 'Testing started'
                sh "make test"
            }
        }

        stage('build') {
            steps {
                echo "Build binary for platform ${params.OS} on ${params.ARCH} started"
                sh "make ${params.OS} ${params.ARCH}"
            }
        }

        stage('image') {
            steps {
                echo "Building docker image for platform ${params.OS} on ${params.ARCH} started"
                sh "make image-${params.OS} ${params.ARCH}"
            }
        }
        
        stage('push image') {
            steps {
                script {
                    docker.withRegistry( '', 'dockerhub' ) {
                    sh "make -n ${params.OS} ${params.ARCH} image push"
                    }
                }
            }
        } 
    }
}
