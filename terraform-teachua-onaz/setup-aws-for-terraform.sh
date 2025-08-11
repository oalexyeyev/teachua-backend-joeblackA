#!/bin/bash

set -euo pipefail

# SETTINGS
PROFILE="sandbox"
USER_NAME="terraform-user"
ROLE_NAME="TerraformExecutionRole"
ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE --query Account --output text)
REGION="us-east-1"

echo "🔧 Creating IAM user: $USER_NAME"
aws iam create-user \
  --user-name $USER_NAME \
  --profile $PROFILE || echo "User already exists, continuing..."

echo "🔐 Creating access key..."
CREDS_JSON=$(aws iam create-access-key \
  --user-name $USER_NAME \
  --profile $PROFILE \
  --query 'AccessKey' \
  --output json)

ACCESS_KEY_ID=$(echo $CREDS_JSON | jq -r .AccessKeyId)
SECRET_ACCESS_KEY=$(echo $CREDS_JSON | jq -r .SecretAccessKey)

echo "💾 Writing credentials to ~/.aws/credentials"
aws configure set aws_access_key_id "$ACCESS_KEY_ID" --profile terraform-user
aws configure set aws_secret_access_key "$SECRET_ACCESS_KEY" --profile terraform-user
aws configure set region "$REGION" --profile terraform-user

echo "✅ User credentials saved under [terraform-user] profile"

# ---- Create Trust Policy ----
TRUST_POLICY_JSON=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::$ACCOUNT_ID:user/$USER_NAME"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
)

echo "🛠️ Creating IAM role: $ROLE_NAME"
aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document "$TRUST_POLICY_JSON" \
  --profile $PROFILE || echo "Role already exists, continuing..."

# ---- Attach policies to role ----
for POLICY in AmazonEC2FullAccess AmazonRDSFullAccess AmazonVPCFullAccess SecretsManagerReadWrite; do
  echo "🔗 Attaching $POLICY to $ROLE_NAME"
  aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/$POLICY \
    --profile $PROFILE
done

# ---- Create Inline Policy for user to AssumeRole ----
ASSUME_ROLE_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME"
    }
  ]
}
EOF
)

echo "🧾 Attaching inline policy to allow $USER_NAME to assume $ROLE_NAME"
aws iam put-user-policy \
  --user-name $USER_NAME \
  --policy-name "AssumeTerraformRolePolicy" \
  --policy-document "$ASSUME_ROLE_POLICY" \
  --profile $PROFILE

# ---- Output Terraform provider block ----
echo -e "\n✅ Setup complete. Use this provider block in your Terraform:\n"
cat <<EOF
provider "aws" {
  region  = "$REGION"
  profile = "terraform-user"
  assume_role {
    role_arn = "arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME"
  }
}
EOF
