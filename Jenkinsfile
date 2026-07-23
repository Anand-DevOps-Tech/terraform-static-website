pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Select the Terraform action to execute'
        )
        string(
            name: 'AWS_REGION',
            defaultValue: 'us-east-1',
            description: 'AWS region for deployment'
        )
    }

    environment {
        TF_DIR = 'terraform'
        AWS_CREDENTIALS_ID = 'aws-credentials' // Jenkins credentials ID (AWS Access Key & Secret Key)
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/anand1590/static-website.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([awsAccessKey(credentialsId: "${env.AWS_CREDENTIALS_ID}", 
                                              accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                              secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir("${env.TF_DIR}") {
                        sh "terraform plan -var='aws_region=${params.AWS_REGION}' -out=tfplan"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.ACTION == 'apply' }
            }
            steps {
                withCredentials([awsAccessKey(credentialsId: "${env.AWS_CREDENTIALS_ID}", 
                                              accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                              secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir("${env.TF_DIR}") {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.ACTION == 'destroy' }
            }
            steps {
                withCredentials([awsAccessKey(credentialsId: "${env.AWS_CREDENTIALS_ID}", 
                                              accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                              secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir("${env.TF_DIR}") {
                        sh "terraform destroy -var='aws_region=${params.AWS_REGION}' -auto-approve"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs(deleteDirs: false, notFailBuild: true)
        }
        success {
            echo "Pipeline executed successfully with action: ${params.ACTION}"
        }
        failure {
            echo "Pipeline execution failed."
        }
    }
}
