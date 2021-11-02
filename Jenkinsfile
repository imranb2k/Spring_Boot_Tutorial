pipeline {
   agent any
    environment {
//        HEROKU_API_KEY = credentials('heroku-api-key')
       AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
       AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
       AWS_DEFAULT_REGION = 'en-west-2'
       ARTIFACT_NAME = 'spring_boot_tutorial-0.0.1-SNAPSHOT.jar'
       AWS_S3_BUCKET = 'elasticbeanstalk-eu-west-2-320263951965'
       AWS_EB_APP_NAME = 'springboot-example'
       AWS_EB_ENVIRONMENT = 'Springbootexample-env-1'
       AWS_EB_APP_VERSION = "${BUILD_ID}"
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
                    step( [ $class: 'JacocoPublisher' ] )
                }
            }
        }
        stage('Deploy') {
            steps {
//                 sh '''
//                     echo $HEROKU_API_KEY | docker login --username=_ --password-stdin registry.heroku.com
//                     docker tag springboot/java-web-app:latest registry.heroku.com/springboot-ci-cd/web
//                     docker build -t springboot/java-web-app:latest .
//                     docker push registry.heroku.com/springboot-ci-cd/web
//                 '''

                    sh'''
                        aws s3 cp ./target/$ARTIFACT_NAME s3://$AWS_S3_BUCKET/$ARTIFACT_NAME
                        aws elasticbeanstalk create-application-version --application-name $AWS_EB_APP_NAME --version-label $AWS_EB_APP_VERSION --source-bundle S3Bucket=$AWS_S3_BUCKET,S3Key=$ARTIFACT_NAME
                        aws elasticbeanstalk update-environment --application-name $AWS_EB_APP_NAME --environment-name $AWS_EB_ENVIRONMENT --version-label $AWS_EB_APP_VERSION
                    '''
            }
        }
//         stage('Release') {
//             steps {
//                 sh 'heroku container:release web --app=springboot-ci-cd'
//             }
//          }
	}
}