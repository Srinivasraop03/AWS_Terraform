pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION     = 'us-east-1'
    }

    stages {
        stage('Checkout Terraform Repo') {
            steps {
                script {
                    dir('terraform') {
                        git branch: 'main', url: 'https://github.com/Srinivasraop03/AWS_Terraform.git'
                    }
                }
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                    sh 'terraform plan -input=false -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Manual Approval') {
            when {
                not { equals expected: true, actual: params.autoApprove }
            }
            steps {
                script {
                    def planText = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply this Terraform plan?",
                          parameters: [text(name: 'Terraform Plan', defaultValue: planText)]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            echo 'Terraform pipeline finished.'
        }
    }
} 
