pipeline {
   agent any
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
                script {
                   dockerImage = docker.build("springboot-example:${env.BUILD_ID}")
                   dockerImage.push('imran4fujitsu/ci-cd-process')
                }
            }
        }
	}
}