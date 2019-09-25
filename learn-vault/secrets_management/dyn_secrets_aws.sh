#!/bin/bash -x

# Enable the AWS Secrets Engine
vault secrets list|grep aws || vault secrets enable -path=aws aws

# Configure the AWS Secrets Engine
vault write aws/config/root \
access_key="$AWS_ACCESS_KEY_ID" \
secret_key="$AWS_SECRET_ACCESS_KEY" \
region="$AWS_DEFAULT_REGION"

# Create a Role to grant EC2 access
vault write aws/roles/ec2-role \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF

vault path-help aws

# Generate a dynamic AWS Secret
vault read aws/creds/ec2-role

echo 'vault lease revoke ...'
