# Databricks CLI API Documentation

## Introduction

The Databricks Command Line Interface (CLI) is a tool that allows you to automate and interact with your Databricks workspaces directly from your terminal or through scripts. It provides commands for managing resources like clusters, files in the Databricks File System (DBFS), jobs, and more, without needing to use the web UI.

This document provides an overview of the CLI, focusing on the commands relevant to the Bitcoin Price Analysis project, and describes the Python wrapper functions created in `databricks_cli_utils.py` to simplify its use. For interactive examples, please refer to the `databricks_cli.API.ipynb` notebook.

---

## Prerequisites Setup

### 1. Install and Configure Databricks CLI

**Installation**:  
Follow the official instructions to install the Databricks CLI:
```bash
pip install databricks-cli
```
Verify the installation:
```bash
databricks --version
```

**Authentication (Configuration)**:  
Generate a Personal Access Token (PAT):

- In your Databricks workspace UI:  
  `User Settings → Access Tokens → Generate new token`  
- Copy the token immediately.

Configure CLI via terminal:
```bash
databricks configure --token
```
Provide:

- **Databricks Host** (e.g. `https://adb-xxxxxxxx.xx.azuredatabricks.net`)
- **Generated PAT**

**Alternative via Environment Variables**:
```bash
export DATABRICKS_HOST=...
export DATABRICKS_TOKEN=...
```

---

### 2. Create Cluster Configuration File (`config/cluster_config.json`)

The `create_cluster_cli` function requires a JSON config:

**Steps**:

1. Create a directory `config` (if not already).
2. Inside it, create a file named `cluster_config.json`.

**Example**:
```json
{
  "cluster_name": "bitcoin-analysis-cluster",
  "spark_version": "13.3.x-scala2.12",
  "node_type_id": "Standard_DS3_v2",
  "num_workers": 1,
  "autotermination_minutes": 60,
  "spark_conf": {
    "spark.databricks.cluster.profile": "singleNode"
  },
  "custom_tags": {
    "Project": "BitcoinAnalysis"
  }
}
```
Adjust `spark_version` and `node_type_id` based on what's available in your region.

---

### 3. Create a Test Databricks Job (UI)

A simple test job is needed for the API notebook.

**Steps**:

1. Create a notebook in Databricks (e.g., `api_test_job_notebook`) with:
   ```python
   print("Test job ran")
   ```

2. In Databricks UI:
   - Go to **Workflows → Create Job**
   - Task name: `Run_Test_Notebook`
   - Type: `Notebook`
   - Source: `Workspace`
   - Select your test notebook
   - Cluster: Choose a **new job cluster** with small specs, auto-terminate after job
   - Job name: `API Test Job`
   - Click **Create**

3. Note down the **Job ID** for later use.

---

## Core Databricks CLI Commands

### `databricks clusters`
- `create --json-file <file>`
- `get --cluster-id <id>`
- `list`
- `delete --cluster-id <id>`
- `permanent-delete --cluster-id <id>`

### `databricks fs`
- `cp <local-path> <dbfs-path>`
- `cp <dbfs-path> <local-path>`
- `ls <dbfs-path>`
- `mkdirs <dbfs-path>`
- `rm <dbfs-path>`

### `databricks jobs`
- `create --json-file <file>`
- `run-now --job-id <id>`
- `list`

### `databricks runs`
- `submit --json '{...}'`
- `get --run-id <id>`
- `list --job-id <id>`

---

## Python Wrappers (`databricks_cli_utils.py`)

This module provides wrapper functions using `subprocess`.

- `_run_databricks_cli(command_list)`  
  → Executes CLI command and returns dict with output.

- `create_cluster_cli(config_file, cluster_id_file)`  
  → Runs cluster create command, stores and returns cluster ID.

- `get_cluster_status_cli(cluster_id)`  
  → Returns cluster state (e.g. `RUNNING`).

- `upload_to_dbfs_cli(local_path, dbfs_path, overwrite)`  
  → Uploads local file to DBFS.

- `download_from_dbfs_cli(dbfs_path, local_path, overwrite)`  
  → Downloads from DBFS.

- `submit_notebook_job_cli(job_id)`  
  → Triggers job run using Job ID.

- `get_job_run_status_cli(run_id)`  
  → Gets job run status dict.

- `delete_cluster_cli(cluster_id)`  
  → Deletes the cluster.

> 🔸 *Note: The module also includes data analysis functions specific to the Bitcoin project.*

---

## References

- **Databricks CLI Docs**:  
  https://docs.databricks.com/en/dev-tools/cli/index.html

- **Databricks REST API**:  
  https://docs.databricks.com/en/dev-tools/api/latest/index.html

- **Interactive Example Notebook**:  
  `databricks_cli.API.ipynb`

