#!/bin/bash
set -euo pipefail


# Helper function
send_slack_alert() {
    local message="$1"
    if [[ -n "$SLACK_WEBHOOK_URL" ]]; then
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"$message\"}" \
            "$SLACK_WEBHOOK_URL" >/dev/null 2>&1 || true
    fi
}


# --------------------------
# Configuration
# --------------------------
JOB_ID=${1:-515902180597777} 
MAX_CLUSTER_WAIT_SECONDS=300     # 5 mins for cluster startup
MAX_JOB_WAIT_MINUTES=30          # 30 mins for job completion
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK"  # Optional
WORKSPACE_URL="https://adb-166759757699610.10.azuredatabricks.net"
LOG_DIR="logs"
CLUSTER_ID_FILE="config/cluster_id.txt"

# Initialize
mkdir -p "$LOG_DIR"
START_TIME=$(date +%s)
echo "🕒 $(date +'%Y-%m-%d %H:%M:%S') - 🚀 Starting Pipeline"

# --------------------------
# 1. Cluster Creation
# --------------------------
echo "🔧 Creating cluster..."
cluster_output=$(bash scripts/create_cluster.sh)
cluster_id=$(grep -o 'cluster-[0-9a-zA-Z-]*' <<< "$cluster_output" | head -1)
echo "$cluster_id" > "$CLUSTER_ID_FILE"
echo "📌 Cluster ID: $cluster_id"

# --------------------------
# 2. Cluster Status Check
# --------------------------
echo "⏳ Waiting for cluster (max $MAX_CLUSTER_WAIT_SECONDS seconds)..."
for i in $(seq 1 $((MAX_CLUSTER_WAIT_SECONDS/10))); do
    status=$(databricks clusters get --cluster-id "$cluster_id" | jq -r '.state')
    [[ "$status" == "RUNNING" ]] && break
    sleep 10
done

if [[ "$status" != "RUNNING" ]]; then
    echo "❌ Cluster $cluster_id failed to start (Status: $status)"
    send_slack_alert "Cluster failed to start (Status: $status)"
    exit 1
fi

# --------------------------
# 3-5. Data Pipeline
# --------------------------
echo "📈 Fetching Bitcoin price..."
python scripts/fetch_bitcoin_price.py >> "$LOG_DIR/fetch_$(date +%Y%m%d).log" 2>&1 || {
    echo "❌ Failed to fetch Bitcoin price"
    exit 1
}

echo "📤 Uploading to DBFS..."
bash scripts/upload_to_dbfs.sh >> "$LOG_DIR/upload_$(date +%Y%m%d).log" 2>&1 || {
    echo "❌ DBFS upload failed"
    exit 1
}

# --------------------------
# 6. Notebook Execution
# --------------------------
echo "📊 Triggering notebook job (ID: $JOB_ID)..."
run_output=$(databricks jobs run-now --job-id "$JOB_ID")
run_id=$(jq -r '.run_id' <<< "$run_output")
echo "🔗 Job Run URL: $WORKSPACE_URL/#job/$JOB_ID/run/$run_id"

# --------------------------
# 7. Job Monitoring
# --------------------------
echo "⏳ Waiting for job completion (max $MAX_JOB_WAIT_MINUTES minutes)..."
end_time=$((START_TIME + MAX_JOB_WAIT_MINUTES*60))
job_status="PENDING"

while [ $(date +%s) -lt $end_time ]; do
    run_info=$(databricks runs get --run-id "$run_id")
    job_status=$(jq -r '.state.life_cycle_state' <<< "$run_info")
    result_state=$(jq -r '.state.result_state // empty' <<< "$run_info")
    
    echo "⏱ Status: $job_status"
    [[ "$job_status" == "TERMINATED" ]] && break
    sleep 10
done

# Save final logs
databricks runs get-output --run-id "$run_id" > "$LOG_DIR/job_${run_id}_$(date +%Y%m%d).log"

# --------------------------
# 8. Result Handling
# --------------------------
if [[ "$job_status" != "TERMINATED" ]]; then
    echo "❌ Job timed out after $MAX_JOB_WAIT_MINUTES minutes"
    send_slack_alert "Job timed out (Status: $job_status)"
    exit 1
elif [[ "$result_state" != "SUCCESS" ]]; then
    echo "❌ Job failed with result: $result_state"
    send_slack_alert "Job failed (Result: $result_state)"
    exit 1
fi

# --------------------------
# 9. Cleanup
# --------------------------
echo "🧹 Terminating cluster $cluster_id..."
databricks clusters delete --cluster-id "$cluster_id"

# --------------------------
# 10. Completion
# --------------------------
DURATION=$(( $(date +%s) - START_TIME ))
echo "✅ $(date +'%Y-%m-%d %H:%M:%S') - Pipeline completed successfully in $(($DURATION/60))m $(($DURATION%60))s"
send_slack_alert "✅ Pipeline completed successfully in $(($DURATION/60))m $(($DURATION%60))s"

