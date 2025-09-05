pipeline {
  agent any
  options { skipDefaultCheckout() }

  parameters {
    booleanParam(name: 'FORCE_BUILD', defaultValue: false, description: 'Set true to bypass commit-message and branch check')
  }

  stages {
    stage('Prepare') {
      steps {
        sh 'echo "Workspace before cleanup: ${WORKSPACE}"; ls -la "${WORKSPACE}" || true'

        sh 'rm -rf -- "${WORKSPACE%/}"/* || true'

        sh 'echo "Workspace after cleanup:"; ls -la "${WORKSPACE}" || true'

        checkout scm

        script {
          def branchName = env.BRANCH_NAME ?: env.GIT_BRANCH ?: sh(returnStdout: true,
            script: "git rev-parse --abbrev-ref HEAD 2>/dev/null || git name-rev --name-only HEAD || true"
          ).trim()

          branchName = branchName.replaceAll(/^refs\\/heads\\//, '').replaceAll(/^origin\\//, '').trim().toLowerCase()

          def lastMsg = sh(returnStdout: true, script: "git log -1 --pretty=%B").trim()

          echo "Detected branch: ${branchName}"
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
