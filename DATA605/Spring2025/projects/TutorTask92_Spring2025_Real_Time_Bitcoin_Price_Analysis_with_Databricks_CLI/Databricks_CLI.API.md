# Databricks CLI Tutorial

## Introduction

This tutorial introduces the **Databricks CLI** — a command-line tool that allows users to interact with their Databricks workspace programmatically. The goal is to demonstrate how to use this interface to build, automate, and manage a Bitcoin price forecasting pipeline.

This file documents the native Databricks CLI commands and wraps them with simplified shell scripts to make them easier to use within automated data workflows.

## Table of Contents

- [1. What is Databricks CLI?](#1-what-is-databricks-cli)
- [2. Why use Databricks CLI?](#2-why-use-databricks-cli)
- [3. Setup & Authentication](#3-setup--authentication)
- [4. Native API Capabilities](#4-native-api-capabilities)
- [5. Custom Shell Wrappers](#5-custom-shell-wrappers)
- [6. Summary of CLI Commands Used](#6-summary-of-cli-commands-used)
- [7. References](#7-references)

---

## 1. What is Databricks CLI?

The Databricks CLI is a command-line interface to interact with Databricks workspaces. It provides access to resources such as clusters, jobs, notebooks, and DBFS (Databricks File System) without needing to open the web UI.

Documentation: [Databricks CLI Docs](https://docs.databricks.com/dev-tools/cli/index.html)

---

## 2. Why use Databricks CLI?

Using CLI enables automation, reproducibility, and integration with tools like Docker or CI/CD systems. In this project, we rely on it to:

- Create and terminate clusters
- Upload and fetch files from DBFS
- Run scheduled or ad hoc notebook jobs
- Monitor execution status

---

## 3. Setup & Authentication

Install the CLI:

```bash
pip install databricks-cli
```

Authenticate using a Personal Access Token (PAT):

```bash
databricks configure --token
# Enter your host URL and token when prompted
```

---

## 4. Native API Capabilities

Below are the main CLI capabilities used in this project:

| Task                        | CLI Command Example                                                                 |
|-----------------------------|--------------------------------------------------------------------------------------|
| Create cluster              | `databricks clusters create --json-file config/cluster_config.json`                 |
| Check cluster status        | `databricks clusters get --cluster-id <CLUSTER_ID>`                                 |
| Terminate cluster           | `databricks clusters delete --cluster-id <CLUSTER_ID>`                              |
| Upload data to DBFS         | `databricks fs cp data/bitcoin_price.json dbfs:/bitcoin/ --overwrite`              |
| Run notebook job            | `databricks jobs run-now --job-id <JOB_ID>`                                         |
| Get job run status          | `databricks runs get --run-id <RUN_ID>`                                             |
| View DBFS contents          | `databricks fs ls dbfs:/bitcoin/`                                                   |

---

## 5. Custom Shell Wrappers

We created simplified wrapper scripts to encapsulate the CLI logic for reusability.

### 5.1 Cluster Creation

**Script**: `scripts/create_cluster.sh`  
**Purpose**: Creates a single-node cluster from JSON config and stores the cluster ID.

### 5.2 Data Upload to DBFS

**Script**: `scripts/upload_to_dbfs.sh`  
**Purpose**: Uploads the `bitcoin_price.json` file to DBFS for notebook consumption.

### 5.3 Full Pipeline

**Script**: `scripts/run_full_pipeline.sh`  
**Purpose**: Automates the entire flow — from cluster creation, data fetch, upload, notebook execution, and cleanup.

---

## 6. Summary of CLI Commands Used

| Component     | Command                                                                 |
|---------------|-------------------------------------------------------------------------|
| Clusters      | `clusters create`, `clusters get`, `clusters delete`                   |
| Jobs          | `jobs run-now`, `runs get`, `runs get-output`                          |
| File System   | `fs cp`, `fs ls`                                                        |
| Authentication| `databricks configure --token`                                          |

---

## 7. References

- [Databricks CLI Documentation](https://docs.databricks.com/dev-tools/cli/index.html)
- [CoinGecko API Docs](https://www.coingecko.com/en/api/documentation)
- [Time Series Forecasting with Python](https://www.analyticsvidhya.com/blog/2021/07/time-series-forecasting-using-python-a-comprehensive-guide/)

---


