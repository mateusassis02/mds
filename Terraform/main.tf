# versão mínima do Terraform necessária para executar o código.
terraform {
  required_version = "~> 1.5.1" # 1.5.0 até 1.5.n  

}

# Especifica o provedor necessário, neste caso, o provedor "aws" na versão 5.5.0.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }
  }

  #  Configura o backend do Terraform para armazenar o estado em um bucket S3, com chave e região específicas. A criptografia do estado está ativada.
  backend "s3" {

    bucket  = "aws-mds"
    key     = "aws-mds.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

# Configura o provedor AWS com a região desejada
provider "aws" {
  region = "us-east-2"


  # Define tags padrão que serão aplicadas aos recursos criados.
  default_tags {
    tags = {
      nome       = "AWS-MDS"
      managed-by = "Mateus Assis"
    }
  }
}

