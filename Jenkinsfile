pipeline {
    agent any // Allows execution on any available Jenkins agent

    parameters {
        choice(name: 'BRANCH',choices: ['main', 'feature'],description: 'Select a branch to build')
        choice(name: 'Action', choices: ['Plan', 'Apply', 'Destroy', 'State', 'Import'], description: 'Pick any one')
        string(name: 'ARGUMENTS', defaultValue: '', description: 'Terraform Arguments (Required for Import)')
    }

    environment {
        ARM_CLIENT_ID        = credentials('ClientID')
        ARM_SUBSCRIPTION_ID  = credentials('SubscriptionID')
        ARM_TENANT_ID        = credentials('TenantID')
        ARM_CLIENT_SECRET    = credentials('ClientSecret')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: params.BRANCH, 
                    credentialsId: 'github-token', 
                    url: 'https://github.com/arya-devsecops/Jenkins-CI-CD-setup.git'
            }
        }

        // Initialize Terraform
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init -upgrade'
                }
            }
        }
        
        // Format Terraform code
        stage('Terraform Code Format Check') {
            steps {
                script {
                    sh 'terraform fmt'
                }
            }
        }
        
        // Validate Terraform code
        stage('Terraform Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        
        // Terraform Plan
        stage('Terraform Plan') {
            when {
                expression { params.Action == 'Plan' && currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    echo 'Executing terraform plan...'
                    sh 'terraform plan -out=plan.out'
                }
            }
        }
        
        // Terraform Apply
        stage('Terraform Apply') {
            when {
                expression { params.Action == 'Apply' && currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    input "Please approve to proceed with Apply"
                    echo 'Executing terraform apply...'
                    sh 'terraform apply "plan.out"'
                }
            }
        }
        
        // Terraform Destroy
        stage('Terraform Destroy') {
            when {
                expression { params.Action == 'Destroy' && currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    input "Please approve to proceed with Destroy"
                    echo 'Executing terraform destroy...'
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
        
        // Terraform Import
        stage('Terraform Import') {
            when {
                expression { params.Action == 'Import' && params.ARGUMENTS != "" }
            }
            steps {
                script {
                    echo "Executing terraform import for Azure account..."
                    sh "terraform import ${params.ARGUMENTS}"
                }
            }
        }
    }
}
