#!/bin/bash
set -e

# Config
JOB_ID=${1:-515902180597777}
MAX_WAIT_SECONDS=300
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK"

echo "🕒 $(date +'%Y-%m-%d %H:%M:%S') - 🚀 Starting Pipeline"

# 1. Create cluster
echo "🔧 Creating cluster..."
cluster_output=$(bash scripts/create_cluster.sh)
cluster_id=$(echo "$cluster_output" | grep -o 'cluster-[0-9a-zA-Z-]*' | head -1)
echo "$cluster_id" > config/cluster_id.txt

# 2. Wait for cluster
echo "⏳ Waiting for cluster (max $MAX_WAIT_SECONDS seconds)..."
for i in $(seq 1 $((MAX_WAIT_SECONDS/10))); do
    status=$(databricks clusters get --cluster-id "$cluster_id" | jq -r '.state')
    [[ "$status" == "RUNNING" ]] && break
    sleep 10
done

if [[ "$status" != "RUNNING" ]]; then
    echo "❌ Cluster $cluster_id failed to start (Status: $status)"
    exit 1
fi

# 3-5. Execute pipeline
echo "📈 Fetching Bitcoin price..."
python scripts/fetch_bitcoin_price.py || exit 1

echo "📤 Uploading to DBFS..."
bash scripts/upload_to_dbfs.sh || exit 1

echo "📊 Running notebook (Job ID: $JOB_ID)..."
run_id=$(databricks jobs run-now --job-id "$JOB_ID" | jq -r '.run_id')

workspace_url="https://adb-166759757699610.10.azuredatabricks.net"
echo "🔗 View job: $workspace_url/#job/$JOB_ID/run/$run_id"

# 6. Cleanup
echo "🧹 Terminating cluster $cluster_id..."
databricks clusters delete --cluster-id "$cluster_id"

# Notification
echo "✅ $(date +'%Y-%m-%d %H:%M:%S') - Pipeline completed successfully!"
if [[ -n "$SLACK_WEBHOOK_URL" ]]; then
  curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"✅ BTC Pipeline succeeded at $(date)\"}" \
    "$SLACK_WEBHOOK_URL" 2>/dev/null || true
fi