import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas

import os
from dotenv import load_dotenv
load_dotenv()

# read demographics data as sample
df = pd.read_sas("data/raw/DEMO_G.xpt", format="xport", encoding="utf-8")
print(df.shape)
print(df.head())

# create snowflake connection
conn = snowflake.connector.connect(
    account=os.environ["SNOWFLAKE_ACCOUNT"],
    user="DBT_USER",
    private_key_file=os.environ["SNOWFLAKE_PRIVATE_KEY_PATH"],
    role="DBT_ROLE",
    warehouse="DBT_WH",
    database="HEALTH_PILLARS",
    schema="RAW",
)

success, nchunks, nrows, _ = write_pandas(conn, df, "DEMO_G", auto_create_table=True, overwrite=True)
print(success, nrows)