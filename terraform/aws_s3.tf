provider "aws" {
  region = "us-east-1"
  profile = "qiross"
}

resource "aws_s3_bucket_public_access_block" "frontend_bucket_public_access_block" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "my-static-frontend-bucket"
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = ["s3:GetObject"]
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
        Principal = "*"
      }
    ]
  })
}


resource "aws_s3_bucket_website_configuration" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "null_resource" "update_app_js" {
  provisioner "local-exec" {
    command = "sed 's/<AZURE_VM_PUBLIC_IP>/${azurerm_public_ip.public_ip.ip_address}/g' ../frontend/app_template.js > ../frontend/app.js"
  }

  depends_on = [azurerm_public_ip.public_ip]
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.frontend_bucket.id
  key    = "index.html"
  source = "../frontend/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "app_js" {
  bucket = aws_s3_bucket.frontend_bucket.id
  key    = "app.js"
  source = "../frontend/app.js"
  content_type = "application/javascript"
  depends_on = [null_resource.update_app_js]
}

output "website_url" {
  value = "http://${aws_s3_bucket.frontend_bucket.bucket}.s3-website-us-east-1.amazonaws.com"
}

