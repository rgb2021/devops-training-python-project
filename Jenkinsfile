#!groovy

//@Library('functions')_

pipeline {
	agent any // Default Agent

  environment {
	  DOCKERHUB_CREDENTIALS=credentials('dockerhub')
      TAG_NAME="0.0.1"//getLastGitTag()
	}

  stages {

    stage('List env vars') {
      steps{
            sh "printenv | sort"
        }
    }

    stage('Test') {
      // Specifies where the entire Pipeline, or a specific stage, will execute in the Jenkins environment depending on where the agent section is placed
    	agent {
      	docker {
        	image 'python:3.6-slim'
        }
      }
      steps {
      	sh 'pip install -r requirements.txt && pytest -v  -l --tb=short --maxfail=1 tests/'
      }
    }
  }

  post {
    always  {
      sh 'docker logout'
      
    }
    success {
      // send mail
      echo "SUCCESS"
    }
  }
  
}


def getLastGitTag() {
    sh "git tag --sort version:refname | head -n 1 > version.tmp"
    String tag = readFile 'version.tmp'
    echo "Branch: ${scm.branches[0].name}"
    echo "Tag, ${tag}." 
    return tag
}