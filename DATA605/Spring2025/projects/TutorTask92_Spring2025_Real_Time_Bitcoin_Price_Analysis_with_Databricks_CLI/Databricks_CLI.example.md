# Project Example: Real-Time Bitcoin Price Analysis Pipeline

## Objective

This project demonstrates building an automated pipeline to fetch Bitcoin price data, perform time series forecasting using Databricks compute, and manage the entire process using the Databricks CLI. The example showcases how the CLI can be used to orchestrate cloud resources and execute analysis tasks programmatically.

## Architecture and Workflow

The pipeline, as demonstrated in the `databricks_cli.example.ipynb` notebook, follows these steps:

1. **Cluster Provisioning (CLI)**:  
   A compute cluster is created on Databricks using a predefined JSON configuration (`config/cluster_config.json`) via the `dcu.create_cluster_cli()` function, which wraps `databricks clusters create`. The script waits for the cluster to reach the "RUNNING" state by polling with `dcu.get_cluster_status_cli()`.

2. **Data Ingestion (Local)**:  
   The latest Bitcoin price is fetched from the CoinGecko API using the `dcu.fetch_bitcoin_data()` function and saved to a local JSON file (`data/bitcoin_price.json`).

3. **Data Staging (CLI)**:  
   The fetched local data file is uploaded to the Databricks File System (DBFS) using the `dcu.upload_to_dbfs_cli()` function (wrapping `databricks fs cp`), making it accessible to the cluster. The target path is `dbfs:/bitcoin/bitcoin_price.json`.

4. **Analysis Job Submission (CLI)**:  
   The core analysis, contained within a separate notebook (`bitcoin_analysis.ipynb` stored in the Databricks workspace), is submitted as a one-time run using the `dcu.submit_notebook_run_cli()` function. This wrapper constructs the necessary JSON payload and uses the `databricks runs submit` command, specifying the analysis notebook's path and targeting the cluster created in Step 1.

5. **Remote Analysis Execution (Databricks Job)**:  
   The `bitcoin_analysis.ipynb` notebook executes on the Databricks cluster. It loads the data from `dbfs:/bitcoin/bitcoin_price.json`, performs data cleaning (using Pandas), trains an ARIMA model (using Statsmodels), generates a forecast, and saves the forecast results as a CSV file to `dbfs:/bitcoin/forecast_output.csv`.

6. **Job Monitoring (CLI)**:  
   The orchestrator notebook waits for the submitted run to complete by periodically checking its status using `dcu.get_job_run_status_cli()` (wrapping `databricks runs get`) until the state is "TERMINATED" and the result is "SUCCESS".

7. **Result Retrieval (CLI)**:  
   Upon successful job completion, the generated `forecast_output.csv` file is downloaded from DBFS to the local `data/` directory using `dcu.download_from_dbfs_cli()`.

8. **Cluster Termination (CLI)**:  
   The cluster created in Step 1 is terminated and deleted using `dcu.delete_cluster_cli()` to ensure resources are released.

9. **Local Visualization**:  
   The downloaded forecast CSV is loaded using Pandas locally. The historical data (re-parsed from the local fetched file) and the forecast data are then plotted together using Matplotlib (`dcu.plot_forecast_data()`) and displayed. *(Note: The appearance of the plot may reflect gaps present in the input data used during the demonstrated run).*

## Components

- **Data Source**: CoinGecko API.  
- **Orchestration**: Databricks CLI (via Python wrappers in `databricks_cli_utils.py`), executed by `databricks_cli.example.ipynb`.  
- **Compute**: Databricks cluster (programmatically managed).  
- **Storage**: Local filesystem (temporary), DBFS (staging/results).  
- **Analysis**: Python notebook (`bitcoin_analysis.ipynb`) on Databricks using Pandas, Statsmodels.  
- **Visualization**: Matplotlib (run locally on downloaded results).  
- **Environment**: Docker (`data605_style`).

## Implementation Notes

- The pipeline relies heavily on the wrapper functions in `databricks_cli_utils.py` to interact with the Databricks CLI.
- The analysis notebook (`bitcoin_analysis.ipynb`) is designed to be self-contained, reading input from and writing output to predefined DBFS paths.
- Error handling (e.g., for cluster start failures, job failures, download failures) is included in the orchestrator notebook to manage the pipeline flow.

## References

- **Executable Orchestration**: See the `databricks_cli.example.ipynb` notebook.  
- **Utility Functions**: See the `databricks_cli_utils.py` module.  
- **Databricks CLI Documentation**: https://docs.databricks.com/en/dev-tools/cli/index.html
