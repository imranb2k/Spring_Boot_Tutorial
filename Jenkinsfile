pipeline {
   agent any
    environment {
       HEROKU_API_KEY = credentials('heroku-api-key')
     }
    stages {
        stage('Build') {
			agent {
                docker {
                    image 'maven:3.8.1-adoptopenjdk-11'
                    args '-v /root/.m2:/root/.m2'
                    reuseNode true
                }
			}
			steps {
				sh 'mvn -B -DskipTests clean package'
			}
			
		}
        stage('Test') {
			agent {
					docker {
						image 'maven:3.8.1-adoptopenjdk-11'
						args '-v /root/.m2:/root/.m2'
						reuseNode true
					}
			}
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                echo $HEROKU_API_KEY | docker login --username=_ --password-stdin registry.heroku.com'
                docker build -t springboot/java-web-app:latest .'
                docker tag springboot/java-web-app:latest registry.heroku.com/springboot-ci-cd/web
                docker push registry.heroku.com/springboot-ci-cd/web
                '''
            }
        }

        stage('Release') {
              steps {
                sh 'heroku container:release web --app=springboot-ci-cd'
              }

	}
}