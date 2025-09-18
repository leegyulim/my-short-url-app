# Terraform이 새로운 키 페어를 직접 생성하도록 합니다.
resource "tls_private_key" "my_pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 생성된 키를 기반으로 AWS에 키 페어를 등록합니다.
resource "aws_key_pair" "my_key" {
  key_name   = "my-aws-key-tf" # 2. AWS에 생성될 키 페어의 이름 (원하면 수정)
  public_key = tls_private_key.my_pk.public_key_openssh
}

# 생성된 프라이빗 키(.pem)를 로컬 파일로 저장합니다.
# 이 파일이 EC2 서버에 접속할 때 사용할 '열쇠'가 됩니다.
resource "local_file" "private_key" {
  content  = tls_private_key.my_pk.private_key_pem
  filename = "my-aws-key-tf.pem" # 4. 내 컴퓨터에 저장될 .pem 파일의 이름
}

# (참고) tls_private_key, local_file 리소스를 사용하려면
# main.tf 맨 위에 provider 설정을 추가해야 합니다.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # 아래 두 provider를 추가해주세요.
    tls = {
      source = "hashicorp/tls"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

# 3. 보안 그룹(방화벽) 생성
resource "aws_security_group" "my_sg" {
  # 5. AWS에 생성될 보안 그룹의 이름
  # "my-sg-tf" 라는 이름으로 보안 그룹이 생성됩니다. 원하면 수정 가능합니다.
  name        = "my-sg-tf"
  description = "Allow SSH and HTTP inbound traffic"

  # (인바운드/아웃바운드 규칙은 수정할 필요 없습니다. 그대로 두세요.)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. EC2 인스턴스(가상 서버) 생성
resource "aws_instance" "my_server" {
  ami           = "ami-02835aed2a5cb1d2a" # 이 값을 확인하고 수정해야 합니다.

  # (인스턴스 타입, 키 이름, 보안 그룹은 위에서 정의한 값을 참조하므로 수정할 필요 없습니다.)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_sg.name]

  tags = {
    #  EC2 인스턴스에 표시될 이름
    # "my-server-tf" 라는 이름으로 EC2 대시보드에 표시됩니다. 원하면 수정 가능합니다.
    Name = "my-server-tf"
  }
}

# 5. (선택사항) 생성된 서버의 IP 주소를 출력
# (이 부분은 수정할 필요 없습니다. 그대로 두세요.)
output "instance_public_ip" {
  value = aws_instance.my_server.public_ip
}