#!/bin/bash

echo "🚀 Starting Full Automation Pipeline"

# 1. Create cluster and store cluster ID
echo "🔧 Creating cluster..."
bash scripts/create_cluster.sh

# 2. Wait ~5 minutes for cluster to spin up
echo "⏳ Waiting for cluster to become active (300 seconds)..."
sleep 300

# 3. Fetch current Bitcoin price
echo "📈 Fetching Bitcoin price from API..."
python scripts/fetch_bitcoin_price.py

# 4. Upload the updated JSON to DBFS
echo "📤 Uploading bitcoin_price.json to DBFS..."
bash scripts/upload_to_dbfs.sh

# 5. Trigger Databricks notebook via job_id
echo "📊 Running forecast notebook..."
databricks jobs run-now --job-id 515902180597777

# Optional 6. Terminate the cluster
cluster_id=$(cat config/cluster_id.txt)
echo "🧹 Terminating cluster $cluster_id to save costs..."
databricks clusters delete --cluster-id "$cluster_id"

echo "✅ Pipeline completed successfully!"
