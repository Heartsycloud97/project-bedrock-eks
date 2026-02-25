# ----------------------------
# S3 Bucket for Lambda Assets
# ----------------------------
resource "aws_s3_bucket" "assets" {
  bucket = "bedrock-assets-${var.student_id}"

  tags = {
    Project = "barakat-2025-capstone"
  }
}

# ----------------------------
# Lambda Function
# ----------------------------
resource "aws_lambda_function" "bedrock_asset_processor" {
  function_name = "bedrock-asset-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  tags = {
    Project = "barakat-2025-capstone"
  }
}
