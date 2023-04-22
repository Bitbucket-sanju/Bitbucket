resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-${aws_vpc.vpc1.id}"
  acl    = "private"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
  }
  depends_on = [aws_vpc.vpc1]
}

terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-lock"
    depends_on     = [aws_s3_bucket.terraform_state]
  }
}

