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

```bash
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

Optionally save forecast to DBFS

🔹 4. Run Full Pipeline Automatically

bash scripts/run_full_pipeline.sh
This shell script executes:

Cluster creation

Data fetching

Upload to DBFS

Notebook execution (future-ready for automation)

📈 Forecasting Methodology
✅ ARIMA Model (statsmodels)

✅ Automatic de-duplication

✅ Plots historical vs predicted prices

✅ Forecasts next 10 timestamps (15-min intervals)

✅ Handles missing/duplicate timestamps

✅ Easily extendable to seasonal models (SARIMA)

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
