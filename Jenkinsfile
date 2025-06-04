pipeline {
  agent any

  environment {
    TF_VAR_ENV = "${params.ENV}"      // dev, staging, prod
  }

  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Pilih Environment')
    booleanParam(name: 'APPLY_AWS', defaultValue: true, description: 'Deploy ke AWS')
    booleanParam(name: 'APPLY_GCP', defaultValue: true, description: 'Deploy ke GCP')
    booleanParam(name: 'APPLY_AZURE', defaultValue: true, description: 'Deploy ke Azure')
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform fmt -check'
        sh 'terraform validate'
      }
    }

    stage('Deploy AWS') {
      when { expression { params.APPLY_AWS } }
      steps {
        dir('modules/vpn_aws_gcp_azure/aws') {
          sh 'terraform init'
          sh 'terraform plan -out=plan.aws'
          input message: "Approve apply AWS VPN?", ok: "Deploy"
          sh 'terraform apply -auto-approve plan.aws'
        }
      }
    }

    stage('Deploy GCP') {
      when { expression { params.APPLY_GCP } }
      steps {
        dir('modules/vpn_aws_gcp_azure/gcp') {
          sh 'terraform init'
          sh 'terraform plan -out=plan.gcp'
          input message: "Approve apply GCP VPN?", ok: "Deploy"
          sh 'terraform apply -auto-approve plan.gcp'
        }
      }
    }

    stage('Deploy Azure') {
      when { expression { params.APPLY_AZURE } }
      steps {
        dir('modules/vpn_aws_gcp_azure/azure') {
          sh 'terraform init'
          sh 'terraform plan -out=plan.azure'
          input message: "Approve apply Azure VPN?", ok: "Deploy"
          sh 'terraform apply -auto-approve plan.azure'
        }
      }
    }

    stage('Notify') {
      steps {
        echo "Deployment selesai untuk: ${params.ENV}"
        // Bisa integrasi ke Slack/email di sini
      }
    }
  }
}
