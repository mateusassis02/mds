# cria uma chave SSH chamada "mds" e carrega a chave pública correspondente a partir de um arquivo.  
resource "aws_key_pair" "mds" {
  key_name   = "mds"
  public_key = file("./mds.pub")
}

# Busca a AMI mais recente do Ubuntu, filtrando por um padrão de nome específico e especificando o proprietário da AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  # Garantir que apenas AMIs disponíveis sejam consideradas
  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["099720109477"] # owner Ubuntu-AWS us-east-2
}

#  Cria uma instância da AWS, utilizando a AMI buscada anteriormente, um tipo de instância específico, uma chave SSH, e adiciona a grupo de segurança existente.
resource "aws_instance" "web" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.xlarge"
  key_name                    = aws_key_pair.mds.key_name
  vpc_security_group_ids      = ["${aws_security_group.SG_MDS.id}"]
  subnet_id                   = "subnet-0fe11bae0eaa3a68b"
  associate_public_ip_address = true

  # Adiciona um volume EBS de 40GB
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 40
    volume_type = "gp2" # tipo de volume SSD
  }


  # tags para identificação da instância
  tags = {
    Name = "SRV-MDS"
    Lab  = "utilizando-Terraform"
    Iac  = "Terraform"
  }
}
