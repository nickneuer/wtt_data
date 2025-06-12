#!/bin/sh
set -e

# Wait for MinIO to be available
until mc alias set local http://minio:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"; do
  echo "Waiting for MinIO..."
  sleep 1
done

# Create bucket (if not exists)
mc mb --ignore-existing local/wtt-data || true

# Create policy
mc admin policy create local wtt-policy /init/policy.json || true

# Create user
mc admin user add local "$MINIO_USER" "$MINIO_PASSWORD" || true

# Attach policy to user
mc admin policy attach local wtt-policy --user="$MINIO_USER"
