pipeline {
  agent any
  options { timestamps() }

  parameters {
    booleanParam(name: 'FORCE_BUILD', defaultValue: false, description: 'Set true to bypass commit-message check')
  }

  stages {
    stage('Prepare') {
      steps {
        checkout scm
        script {
          def branchName = sh(returnStdout: true, script: "git rev-parse --abbrev-ref HEAD").trim()
          def lastMsg = sh(returnStdout: true, script: "git log -1 --pretty=%B").trim()

          echo "Branch: ${branchName}"
          echo "Last commit message: ${lastMsg}"

          if (!params.FORCE_BUILD && !(branchName == 'main' && lastMsg.toLowerCase().contains('final'))) {
            echo "Skipping build: not a push to main with 'final' in commit message and FORCE_BUILD=false."
            currentBuild.result = 'NOT_BUILT'
            error("Aborting pipeline: conditions not met.")
          }
        }
      }
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
