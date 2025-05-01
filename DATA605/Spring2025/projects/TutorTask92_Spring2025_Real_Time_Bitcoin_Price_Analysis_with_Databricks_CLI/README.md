# Real-Time Bitcoin Price Analysis using Databricks CLI

**Author**: Ritik Pratap Singh  
**Date**: 2025-04-30  
**Course**: DATA605 - Spring 2025

## Project Overview

This project implements a pipeline to fetch real-time Bitcoin price data from the CoinGecko API, perform time-series forecasting using an ARIMA model on Databricks compute, and orchestrate the entire workflow using the Databricks Command Line Interface (CLI).

The primary demonstration uses a Jupyter notebook (`databricks_cli.example.ipynb`) running within a Docker container to manage the pipeline steps: creating a Databricks cluster, fetching data, uploading it to DBFS, submitting the analysis notebook as a run on the cluster, monitoring completion, downloading results, and cleaning up the cluster. An auxiliary notebook (`databricks_cli.API.ipynb`) demonstrates the core Databricks CLI commands through Python wrappers.

---

## Project Files

- `README.md`: This file.  
- `databricks_cli_utils.py`: Helper functions for the Databricks CLI, data fetching, ARIMA modeling, and plotting.  
- `databricks_cli.API.ipynb` & `databricks_cli.API.md`: Demo of CLI commands via Python wrappers.  
- `databricks_cli.example.ipynb` & `databricks_cli.example.md`: Orchestrator for end-to-end pipeline.  
- `bitcoin_analysis.ipynb`: (Upload to Databricks Workspace) Analysis notebook using Pandas & Statsmodels.  

### Directories & Scripts

- `config/`:  
  - `cluster_config.json`: JSON spec for cluster creation.  
  - `cluster_id.txt`: Generated cluster ID.  
- `data/`: Local storage for fetched data and results.  
- `output_plots/`: Local folder for saved visualizations.  
- `scripts/`: Shell scripts for pipeline automation (`run_pipeline.sh`, etc.).  
- `requirements.txt`: Python dependencies.  
- `Dockerfile`: Docker image definition (DATA605 style).  
- `docker_build.sh`, `docker_bash.sh`, `docker_jupyter.sh`, `docker_name.sh`: Docker helper scripts.  

---

## Setup and Dependencies

### Prerequisites

- **Git** to clone this repo.  
- **Docker** Desktop/Engine installed and running.  
- **Databricks workspace** (Azure, AWS, GCP).  
- **Databricks PAT**: Personal Access Token from your User Settings.  
- **Python 3.8+** on the host for initial CLI configuration.  

---

## Cloning the Repository

```bash
# Clone the main tutorials repo and navigate into the project folder
git clone https://github.com/causify-ai/tutorials.git
cd tutorials/DATA605/Spring2025/projects/TutorTask92_Spring2025_Real_Time_Bitcoin_Price_Analysis_with_Databricks_CLI
```

---

## Building and Running the Docker Container (data605_style)

### 1. Build the Docker Image

```bash
chmod +x docker_*.sh
./docker_build.sh
```
> **Note:** Docker is run with `--rm` by default, so any CLI config you do _inside_ the container will be lost when you exit.

### 2. Start an Interactive Bash Shell

```bash
# Mount your Databricks CLI config for persistence
./docker_bash.sh --mount-config
```
- Your project is mounted at `/data` inside the container.  
- Exit the shell to remove the container.

### 3. Launch JupyterLab

```bash
./docker_jupyter.sh --mount-config
```
- Opens JupyterLab on port 8888.  
- Access it at `http://localhost:8888/lab?token=...`.  
- Use `Ctrl+C` in the terminal to stop.

#### Env-var Shortcut (No Interactive Configuration)

If you prefer not to mount `~/.databrickscfg`, pass your workspace and token as environment variables:

```bash
docker run --rm -it \
  -e DATABRICKS_HOST="https://<your-workspace>.cloud.databricks.com" \
  -e DATABRICKS_TOKEN="dapiXXXXXXXXXXXXXXXX" \
  -v "$(pwd)":/data \
  -p 8888:8888 \
  umd_data605/bitcoin_cli_project \
  bash --noprofile --norc
```

### 4. (Optional) Install Python Dependencies

```bash
# Inside the container shell at /data:
pip3 install -r requirements.txt
```

---

## Prepare Databricks Workspace

1. Upload `bitcoin_analysis.ipynb` to your Databricks Workspace.  
2. Copy its workspace path (e.g., `/Users/you@example.com/bitcoin_analysis`).  
3. Set `ANALYSIS_NOTEBOOK_PATH` in `databricks_cli.example.ipynb`.  
4. Ensure `config/cluster_config.json` is created and correct.

### Optional: Test Job for API Notebook

Create a simple job in Databricks and update `JOB_ID` in `databricks_cli.API.ipynb`.

---

## Usage Guide

### Interactive Notebook

1. `./docker_jupyter.sh --mount-config`  
2. Open `databricks_cli.API.ipynb` or `databricks_cli.example.ipynb` in JupyterLab.  
3. Run cells sequentially.

### Batch Notebook Execution

```bash
docker run --rm -v "$(pwd)":/data umd_data605/bitcoin_cli_project \
  bash -c "cd /data && \
    jupyter nbconvert --to notebook --execute databricks_cli.example.ipynb \
                    --output Executed.ipynb"
```

---

### Alternative Pipeline Script

```bash
./docker_bash.sh --mount-config
./scripts/run_pipeline.sh
```

---

### Troubleshooting

- **No `/data` directory**: Ensure you’re running in Bash (Git Bash/WSL), not PowerShell.  
- **CLI commands fail**: Use `--mount-config` or the Env-var shortcut above.

---

## References

- [Databricks CLI Documentation](https://docs.databricks.com/en/dev-tools/cli/index.html)  
- [CoinGecko API Docs](https://www.coingecko.com/en/api)  
- [Statsmodels ARIMA Docs](https://www.statsmodels.org/stable/generated/statsmodels.tsa.arima.model.ARIMA.html)

