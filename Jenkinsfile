#!groovy

//@Library('functions')_

pipeline {
	agent any // Default Agent
    // triggers {
    //     cron('H */4 * * 1-5')
    // }

    parameters {
        booleanParam(name: 'IntegrationTest', defaultValue: true, description: 'Test in DEV Environment??')
    }
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
        DOCKERHUB_HOST="contrerasadr"
        TAG_NAME=getLastGitTag()
    }

    stages {

        stage('List env vars') {
            steps{
                sh "printenv | sort"
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t devops-training-flask-app -f Dockerfile .'
            }
        }

        stage('Unit Test') {
            agent {
                docker {
                    image 'devops-training-flask-app'
                }
            }
            steps {
                sh 'pytest -v -l --tb=short --maxfail=1 tests/'
            }
        }

        stage('DEV Env. Deployment') {
            // when {
            //     anyOf {
            //         branch 'develop'
            //         parameter name: 'IntegrationTest', value: true
            //     }
            // }
            steps {
                sh 'docker-compose pull'
                sh 'docker-compose up --build -d'
            }   
        } 

        stage('Integration Test') {
            script {
                def response = sh(script: 'curl -XPOST -sLI -w "%{http_code}" http://localhost:5001 -o /dev/null', returnStdout: true)
                if (response != null) {
                    def statusCode = response.trim()
                    echo "HTTP status code: $statusCode"
                    // Now you can take different actions based on the status code
                    if (statusCode != '200' && statusCode != '201') {
                        error("Returned status code = $statusCode when calling $url")
                    }
                } else {
                    error("Failed to retrieve response from curl command.")
                }
            }
        }
        

        stage('Docker Push') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker tag python-app $DOCKERHUB_HOST/devops-training-flask-app:$TAG_NAME'
                sh 'docker push $DOCKERHUB_HOST/devops-training-flask-app:$TAG_NAME'
            }
        }

        stage('Deploy PRO') {
            when {
                branch 'master'
            }
            steps {
                echo 'Deploying to PRO'
            }
        }
    }

    post {
        always  {
            sh 'docker logout'
            sh 'docker-compose down --volumes'
            
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
    tag = tag if tag != "" else "0.0.1"
    echo "Branch: ${scm.branches[0].name}"
    echo "Tag, ${tag}." 
    return tag
}