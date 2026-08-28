import os
import pandas as pd
import requests
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
from dotenv import load_dotenv

load_dotenv()

RAW_DATA_DIR = "data/raw"

NUTRITION_FILES = [
    ("DR1TOT_G", "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DR1TOT_G.XPT"),
    ("DR2TOT_G", "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DR2TOT_G.XPT"),
    ("DS1TOT_G", "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DS1TOT_G.XPT"),
    ("DS2TOT_G", "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DS2TOT_G.XPT")
]

def download_file(file_name: str, url: str) -> str:
    """Download an NHANES XPT file to the local raw data folder, return the local path."""
    os.makedirs(RAW_DATA_DIR, exist_ok = True)
    local_path = os.path.join(RAW_DATA_DIR, f"{file_name}.xpt")

    response = requests.get(url)
    response.raise_for_status() # t hrows an error if download fails (e.g. 404)

    with open(local_path, "wb") as f:
        f.write(response.content)

    return local_path

def ingest_file(file_name: str, url: str, conn) -> None:
    """Download one NHANES file, parse it, and load it into Snowflake as a raw table."""
    print(f"--- Ingesting {file_name} ---")

    local_path = download_file(file_name, url)
    df = pd.read_sas(local_path, format = "xport", encoding = "utf-8")
    print(f"{file_name}: {df.shape[0]} rows, {df.shape[1]} columns")

    success, nchunks, nrows, _ = write_pandas(
        conn, df, file_name, auto_create_table = True, overwrite = True
    )
    print(f"{file_name}: loaded {nrows} rows, success={success}")

def main():
    conn = snowflake.connector.connect(
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        user="DBT_USER",
        private_key_file=os.environ["SNOWFLAKE_PRIVATE_KEY_PATH"],
        role="DBT_ROLE",
        warehouse="DBT_WH",
        database="HEALTH_PILLARS",
        schema="RAW",
    )

    for file_name, url in NUTRITION_FILES:
        ingest_file(file_name, url, conn)

    conn.close()

if __name__ == "__main__":
    main()