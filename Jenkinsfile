pipeline {
    parameters {
        booleanParam(
            name: 'autoApprove',
            defaultValue: false,
            description: 'Automatically run terraform apply after plan?'
        )
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
                git branch: 'main', url: 'https://github.com/Srinivasraop03/AWS_Terraform.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                sh '''
                    echo "🔧 Initializing Terraform..."
                    terraform init -input=false

                    echo "📝 Generating Terraform plan..."
                    terraform plan -input=false -out=tfplan

                    echo "📄 Saving readable plan output..."
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }

        stage('Manual Approval') {
            when {
                not { equals expected: true, actual: params.autoApprove }
            }
            steps {
                script {
                    def planText = readFile('tfplan.txt')
                    input message: "🟢 Do you approve applying this Terraform plan?",
                          parameters: [text(name: 'Terraform Plan', defaultValue: planText)]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    echo "🚀 Applying Terraform plan..."
                    terraform apply -auto-approve tfplan
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Terraform provisioning completed successfully!'
        }
        failure {
            echo '❌ Terraform pipeline failed. Check logs above.'
        }
        always {
            echo '🏁 Terraform pipeline finished.'
        }
    }
}
