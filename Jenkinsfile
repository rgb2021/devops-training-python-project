#!groovy

//@Library('functions')_

pipeline {
	agent any // Default Agent

  environment {
	  DOCKERHUB_CREDENTIALS=credentials('dockerhub')
      DOCKERHUB_HOST="contrerasadr"
      TAG_NAME="0.0.1"//getLastGitTag()
	}

  stages {

    stage('List env vars') {
      steps{
            sh "printenv | sort"
        }
    }

     stage('Docker Build') {
        steps {
            sh 'docker build -t python-app -f Dockerfile .'
        }
    }

    stage('Test') {
      // Specifies where the entire Pipeline, or a specific stage, will execute in the Jenkins environment depending on where the agent section is placed
    	agent {
      	docker {
        	image 'python-app'
        }
      }
      steps {
      	sh 'pytest -v -l --tb=short --maxfail=1 tests/'
      }
    }

    stage('Docker Push') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      	sh 'docker tag python-app $DOCKERHUB_HOST/scalian_training_python-app:$TAG_NAME'
        sh 'docker push $DOCKERHUB_HOST/scalian_training_python-app:$TAG_NAME'
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