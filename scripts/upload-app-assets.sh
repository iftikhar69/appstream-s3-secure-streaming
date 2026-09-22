#!/usr/bin/env bash
#
# upload-app-assets.sh
# Uploads AppStream application assets to the S3 storage bucket and
# verifies the upload by listing bucket contents.
#
# Usage: ./upload-app-assets.sh

set -euo pipefail

BUCKET="my-appstream-storage"
REGION="us-east-1"
SOURCE_DIR="./app"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: source directory '$SOURCE_DIR' not found. Run this from the project root." >&2
  exit 1
fi

echo "Uploading $SOURCE_DIR to s3://$BUCKET/app/ ..."
aws s3 cp "$SOURCE_DIR" "s3://$BUCKET/app/" \
  --recursive \
  --region "$REGION"

echo ""
echo "Upload complete. Verifying bucket contents:"
aws s3 ls "s3://$BUCKET/app/" --region "$REGION"
