# 🚀 Bitcoin Price Forecasting Pipeline with Databricks CLI

An automated real-time data pipeline to collect, store, analyze, and forecast Bitcoin prices using Python and Databricks CLI.

---

## 🌍 Overview

This project implements a fully automated pipeline that fetches Bitcoin prices every 15 minutes using the CoinGecko API, stores the data in Databricks File System (DBFS), and uses ARIMA modeling to forecast future prices.

The entire flow is orchestrated through shell scripts and the Databricks CLI — making it production-ready, modular, and scalable.

---

## 🌟 Key Features

- ✅ Real-time data ingestion from [CoinGecko API](https://www.coingecko.com/en/api/documentation)
- ✅ Automated Databricks CLI workflows: create cluster, upload to DBFS, run jobs
- ✅ Time-series modeling using ARIMA (with `statsmodels`)
- ✅ Full pipeline automation via shell scripts
- ✅ Robust project structure with error handling and extensibility

---

## 🛠️ Tech Stack

| Tool            | Purpose                              |
|-----------------|--------------------------------------|
| Databricks CLI  | Automate workspace, clusters, DBFS   |
| DBFS            | Distributed storage for raw data     |
| Python 3.8+     | Scripting, modeling, transformation  |
| Pandas          | Data cleaning & manipulation         |
| Statsmodels     | ARIMA modeling & diagnostics         |
| CoinGecko API   | Free Bitcoin price data source       |

---

## 📥 Installation & Setup

### ✅ Prerequisites

- Databricks account (Azure or Community Edition)
- Python 3.8+
- `databricks-cli` installed (`pip install databricks-cli`)
- Personal Access Token (PAT) from your Databricks workspace

---

### 🔧 Setup Instructions

    # Clone the project
    git clone https://github.com/ritik294/tutorials.git
    cd tutorials/Spring2025_Real_Time_Bitcoin_Price_Analysis_with_Databricks_CLI

    # Create virtual environment
    python -m venv venv
    venv\Scripts\activate      # Windows
    # OR
    source venv/bin/activate   # Mac/Linux

    # Install dependencies
    pip install -r requirements.txt

    # Configure Databricks CLI
    databricks configure --token
    > Enter host: https://<your-workspace>.cloud.databricks.com
    > Enter token: <your_personal_access_token>

    💡 Optional: If you face permission issues with shell scripts, make them executable:
        chmod +x scripts/*.sh

📒 Register Notebook as a Databricks Job (One-Time Setup)
    To run the notebook automatically from the shell script, you need to create a Databricks job once:

    Open your Databricks workspace.

    Go to Jobs → Create Job.

    Choose your notebook: /Workspace/bitcoin_analysis
    (or your actual path in the workspace)

    Select a cluster (existing or new).

    Click Create, and note the generated Job ID.

    ✅ Use this Job ID in run_full_pipeline.sh
    bash scripts/run_full_pipeline.sh <your_job_id_here>

    Note: run_full_pipeline.sh uses a default Job ID fallback if not provided.


🏗️ Project Structure

    Spring2025_Real_Time_Bitcoin_Price_Analysis_with_Databricks_CLI/
    ├── data/
    │   └── bitcoin_price.json             # Local collected BTC data
    ├── notebooks/
    │   └── bitcoin_forecast.ipynb         # ARIMA modeling in Databricks
    ├── scripts/
    │   ├── fetch_bitcoin_price.py         # Gets BTC price from CoinGecko API
    │   ├── upload_to_dbfs.sh              # Uploads data to DBFS
    │   ├── create_cluster.sh              # Creates a Databricks cluster
    │   └── run_full_pipeline.sh           # Full automation pipeline (cluster → fetch → upload → run)
    ├── .gitignore
    ├── README.md
    └── requirements.txt


🚦 How to Run
🔹 1. Fetch Real-Time Bitcoin Price
        python scripts/fetch_bitcoin_price.py

        For automated collection every 15 minutes:
        for i in {1..500}; do python scripts/fetch_bitcoin_price.py; sleep 900; done
🔹 2. Upload to Databricks File System (DBFS)
        bash scripts/upload_to_dbfs.sh

        This stores the data in:

        dbfs:/bitcoin/bitcoin_price.json
🔹 3. Run Databricks Notebook for Forecasting
        Open your Databricks workspace

        Attach the cluster created via CLI or manually

        Run notebooks/bitcoin_forecast.ipynb to:

        Clean & deduplicate data

        Perform ARIMA forecasting

        Plot and visualize results

        save forecast to DBFS

🔹 4. Run Full Pipeline Automatically

        This shell script handles the entire workflow:

        ✅ Cluster creation via CLI

        ✅ Waits until cluster is in RUNNING state

        ✅ Fetches latest Bitcoin price from CoinGecko

        ✅ Uploads to DBFS

        ✅ Triggers Databricks job (runs notebook automatically)

        ✅ Waits for job to complete

        ✅ Terminates the cluster

        ✅ Logs outputs to logs/ folder

        ✅ Sends Slack alert (if webhook is configured)

            scripts/run_full_pipeline.sh <your_job_id_here>

🔹 5. 📈 Forecasting Methodology

    ✅ ARIMA Model (statsmodels)

    ✅ Automatic de-duplication

    ✅ Plots historical vs predicted prices

    ✅ Forecasts next 10 timestamps (15-min intervals)

    ✅ Handles missing/duplicate timestamps

    ✅ Easily extendable to seasonal models (SARIMA)

    ✅ Saves forecast output to `/dbfs/bitcoin/forecast_output.csv` with timestamp, model info

📚 References & Resources
    
    Databricks CLI Documentation :https://docs.databricks.com/dev-tools/cli/index.html

    CoinGecko API Docs : https://www.coingecko.com/en/api/documentation

    Statsmodels ARIMA Guide : https://www.statsmodels.org/stable/generated/statsmodels.tsa.arima.model.ARIMA.html

    Databricks DBFS Docs : https://docs.databricks.com/dbfs/index.html

🤝 Contributing
    Fork the repo, make changes in a feature branch, and submit a PR.
    PRs should include a meaningful description, passing scripts, and updated docs if needed.

📜 License
    This project is licensed under the MIT License. See the LICENSE file for details.


🕐 Automate Pipeline on Schedule
    To run the pipeline every X minutes:

    **Windows:**
    - Use Task Scheduler to run `run_full_pipeline.sh` via `bash`

    **Mac/Linux:**
    Add to `crontab -e`:
    ```bash
    */30 * * * * /path/to/your/repo/scripts/run_full_pipeline.sh <job_id>


📽️ Demo Video (Coming Soon)
    A 5-minute screen recording showing:

    CLI cluster creation

    API ingestion

    Upload to DBFS

    Notebook forecasting + visualization

    Full automation via shell script

🙋‍♂️ Author
    Ritik
    Data Science Graduate Student, UMD
    GitHub: ritik294
