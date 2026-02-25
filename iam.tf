# -----------------------------
# Lambda Execution Role
# -----------------------------
resource "aws_iam_role" "lambda_role" {
  name = "bedrock-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -----------------------------
# Developer Read-Only User
# -----------------------------
resource "aws_iam_user" "bedrock_dev" {
  name = "bedrock-dev-view"

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_iam_user_policy_attachment" "read_only" {
  user       = aws_iam_user.bedrock_dev.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Allow this user upload to S3 assets bucket (Required!)
resource "aws_iam_policy" "bedrock_bucket_upload" {
  name = "BedrockAssetsUploadPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ]
      Resource = "arn:aws:s3:::bedrock-assets-${var.student_id}/*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "upload_attach" {
  user       = aws_iam_user.bedrock_dev.name
  policy_arn = aws_iam_policy.bedrock_bucket_upload.arn
}