pipeline {
  agent any

  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Install Node & PM2') {
      steps {
        sh 'chmod 755 scripts/*'
        sh 'scripts/install-node-pm2.sh'
      }
    }

    stage('Build & Run with PM2') {
      steps {
        sh 'scripts/deploy-app.sh'
      }
    }
  }
}
