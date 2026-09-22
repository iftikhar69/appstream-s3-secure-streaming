#!/usr/bin/env bash
#
# validate-iam-policy.sh
# Simulates the AppStreamInstanceRole's permissions against the storage
# bucket to confirm reads are allowed and writes/deletes are denied,
# BEFORE attaching the role to a live AppStream fleet.
#
# Usage: ./validate-iam-policy.sh

set -euo pipefail

ROLE_ARN="arn:aws:iam::123456789012:role/AppStreamInstanceRole"
BUCKET_ARN="arn:aws:s3:::my-appstream-storage"

echo "Simulating policy for $ROLE_ARN ..."
echo ""

aws iam simulate-principal-policy \
  --policy-source-arn "$ROLE_ARN" \
  --action-names s3:GetObject s3:ListBucket s3:PutObject s3:DeleteObject \
  --resource-arns "$BUCKET_ARN" "$BUCKET_ARN/*"

echo ""
echo "Expected result: GetObject/ListBucket = allowed, PutObject/DeleteObject = denied."
echo "If PutObject or DeleteObject show 'allowed', the deny statement in"
echo "policies/appstream-s3-readonly-policy.json is not attached correctly — stop and fix before deploying."
