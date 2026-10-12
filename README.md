# health-pillars-pipeline

An ELT pipeline that turns public CDC NHANES health survey data into a tested, documented dimensional model in Snowflake, built with Python and dbt.

## 1. Overview

`health-pillars-pipeline` takes raw survey files from the CDC's [National Health and Nutrition Examination Survey (NHANES)](https://www.cdc.gov/nchs/nhanes/) and builds an analytics-ready data model on top of them. It is also a hands-on portfolio project for building my data engineering skills in the open.

**Data flow**

```
CDC NHANES (.XPT files)
        │  Python: download, parse, load          scripts/
        ▼
Snowflake  HEALTH_PILLARS.RAW        raw tables, loaded as-is
        │  dbt: clean, rename, decode, average    dbt/models/staging/
        ▼
Snowflake  HEALTH_PILLARS.STAGING    views: stg_demographics, stg_nutrition
        │  dbt: model for analysis                dbt/models/marts/
        ▼
Snowflake  HEALTH_PILLARS.MARTS      tables: dim_respondent, fct_nutrition
```

**Current scope (NHANES 2011–2012 cycle)**

| Layer | What exists |
|---|---|
| Ingestion | Python scripts download NHANES demographics and dietary files (food and supplement intake, days 1 and 2) and load them into Snowflake using key-pair authentication. Near-zero floats produced when reading SAS transport files are converted back to true zeros, and missing values stay NULL. |
| Staging | `stg_demographics` casts, renames, and decodes coded survey values. `stg_nutrition` combines food and supplement intake for each recall day and averages nutrients across the two days. |
| Marts | `dim_respondent` is the respondent dimension, with age groups and decoded demographics. `fct_nutrition` holds one row per respondent with average daily nutrient intake, a data availability flag, and a derived omega-6 to omega-3 ratio. |
| Testing | Generic tests (`unique`, `not_null`, `accepted_values`) on sources and models, plus a custom generic test, `value_between`, for range checks. |
| Reusable code | Macros `sum_or_null` and `avg_or_null` handle the NULL-aware arithmetic that survey data needs. `generate_schema_name` overrides dbt's default schema naming. |

**Skills demonstrated**

| Skill | Where to see it |
|---|---|
| Snowflake | Dedicated role, warehouse, database and schemas; service user with key-pair auth; `write_pandas` loading ([scripts/](scripts)) |
| dbt | Sources, layered models, materialization by layer, Jinja macros, custom generic tests, YAML documentation ([dbt/](dbt)) |
| SQL | CTE-based models, `CASE` decoding, NULL-safe arithmetic, derived metrics ([stg_nutrition.sql](dbt/models/staging/stg_nutrition.sql), [fct_nutrition.sql](dbt/models/marts/fct_nutrition.sql)) |
| Dimensional modeling | Staging-to-mart layering, a dimension keyed on the NHANES respondent ID, and a fact table at a documented grain ([dim_respondent.sql](dbt/models/marts/dim_respondent.sql), [fct_nutrition.sql](dbt/models/marts/fct_nutrition.sql)) |
| Data quality | Tests at both the source and model layers, plus range validation for nutrient values |
| Python | Download, parse and load scripts with environment-based configuration |
| Git | Small, descriptive commits that follow the build order of the project |

**Roadmap**

- [x] Ingestion proof of concept (Python → Snowflake)
- [x] Staging layer with tests (demographics, nutrition)
- [x] Respondent dimension and nutrition fact table
- [ ] Health outcome data (body measures, blood pressure, labs, depression screener, mortality linkage)
- [ ] Physical activity and sleep data
- [ ] CI/CD with GitHub Actions (`dbt build` on pull requests)
- [ ] Orchestration with Airflow
- [ ] Additional NHANES cycles

## 2. What makes it more than a tutorial

- **The data is real, and so are the problems.** NHANES uses coded values, top-coded ages and incomes, missing responses, and nutrient data split across separate food and supplement files. This pipeline handles each of those cases instead of working from a clean toy dataset.
- **Quality is checked, not assumed.** Tests run at the source and model layers, and the custom `value_between` test catches out-of-range values. Models are documented in YAML, so the data dictionary lives next to the code.
- **The design follows the data warehouse practices that dbt teams use.** It has a clear raw → staging → marts separation, views for cheap staging, tables for the marts, reusable macros, and no secrets in the repo (key-pair auth and a gitignored `.env`).
- **The domain is health analytics.** Linking demographics to nutrition intake is the kind of cross-file join that population-health, life-sciences, and healthtech analytics teams do routinely.

## 3. Design decisions and limitations

- **Grain.** `dim_respondent` has one row per NHANES respondent. `fct_nutrition` has one row per respondent who appears in the dietary files, holding average daily intake across the available recall days.
- **Food and supplements.** Intake from food and supplements is summed within each recall day, then averaged across the two days. If only one day has a reliable recall, that day stands in for the average, and the `data_availability` column says which case applies.
- **Respondents without nutrition data.** Respondents whose recall was unreliable or not done are kept in the fact table and labeled `No data`. Respondents who have no dietary record at all are absent from it, so use a left join from `dim_respondent` when you need everyone.
- **Top-coded values.** NHANES caps age, income-to-poverty ratio, and family size. The dimension keeps boolean flags that mark capped values.
- **Omega ratio.** The omega-6 to omega-3 ratio uses EPA and DHA only, with linoleic acid as the omega-6 term. It is null when omega-3 intake is zero and heavily right-skewed, because trace omega-3 intake produces very large values that are not errors.
- **Survey weights are not applied.** NHANES oversamples some groups on purpose, and correct national estimates require its survey weights and design-based variance methods. This project does not implement them, so results describe the sample, not the US population. The goal here is the pipeline and the model, not publication-grade inference.
- **Scope.** Dental, environmental exposure, and infectious disease files are excluded because they do not map to the project's behavior and health pillars.

## 4. Setup

### Prerequisites

- Python 3.10+ (developed on 3.14)
- A Snowflake account. A [free trial](https://signup.snowflake.com/) is enough.
- `openssl` for generating a key pair

### Steps

**1. Clone the repo and create a virtual environment**

```bash
git clone https://github.com/jeffcavanagh/health-pillars-pipeline.git
cd health-pillars-pipeline
python -m venv .venv
source .venv/bin/activate
pip install dbt-core dbt-snowflake pandas requests python-dotenv "snowflake-connector-python[pandas]"
```

**2. Set up Snowflake** (as `ACCOUNTADMIN` or equivalent). The names below match what the code expects.

```sql
CREATE WAREHOUSE DBT_WH WAREHOUSE_SIZE = XSMALL AUTO_SUSPEND = 60;
CREATE DATABASE HEALTH_PILLARS;
CREATE SCHEMA HEALTH_PILLARS.RAW;
CREATE ROLE DBT_ROLE;
GRANT USAGE, CREATE SCHEMA ON DATABASE HEALTH_PILLARS TO ROLE DBT_ROLE;
GRANT USAGE, CREATE TABLE ON SCHEMA HEALTH_PILLARS.RAW TO ROLE DBT_ROLE;
GRANT USAGE ON WAREHOUSE DBT_WH TO ROLE DBT_ROLE;
CREATE USER DBT_USER DEFAULT_ROLE = DBT_ROLE DEFAULT_WAREHOUSE = DBT_WH;
GRANT ROLE DBT_ROLE TO USER DBT_USER;
```

The `STAGING` and `MARTS` schemas are created by dbt on first run.

**3. Create a key pair for `DBT_USER`**

```bash
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out dbt/dbt_user_key.p8 -nocrypt
openssl rsa -in dbt/dbt_user_key.p8 -pubout -out dbt/dbt_user_key.pub
```

Register the public key (the contents of `dbt_user_key.pub` without the header and footer lines) in Snowflake:

```sql
ALTER USER DBT_USER SET RSA_PUBLIC_KEY = '<public key contents>';
```

`*.p8` and `.env` are gitignored. Never commit the private key.

**4. Configure environment variables.** Create a `.env` file in the project root:

```
SNOWFLAKE_ACCOUNT=<your_org>-<your_account>
SNOWFLAKE_PRIVATE_KEY_PATH=/absolute/path/to/dbt/dbt_user_key.p8
```

**5. Configure the dbt profile** in `~/.dbt/profiles.yml`:

```yaml
health_pillars_pipeline:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_org>-<your_account>
      user: DBT_USER
      private_key_path: /absolute/path/to/dbt/dbt_user_key.p8
      role: DBT_ROLE
      warehouse: DBT_WH
      database: HEALTH_PILLARS
      schema: RAW
      threads: 4
```

**6. Verify the connection**

```bash
cd dbt
dbt debug
```

## 5. Running the pipeline

All commands run from the project root with the virtual environment active.

### Step 1: Load raw data into Snowflake

```bash
# Dietary files: downloads DR1TOT_G, DR2TOT_G, DS1TOT_G, DS2TOT_G into data/raw/ and loads them
python scripts/ingest_nutrition.py

# Demographics: reads data/raw/DEMO_G.xpt, so download it first
mkdir -p data/raw
curl -o data/raw/DEMO_G.xpt https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DEMO_G.XPT
python scripts/ingest_demo.py
```

Each script replaces its raw table on every run, so re-running is safe. Tables land in `HEALTH_PILLARS.RAW`. Downloaded files in `data/raw/` are gitignored.

### Step 2: Build and test the models

```bash
cd dbt
dbt build                          # run models and tests in dependency order
```

Useful variations:

```bash
dbt build --select stg_demographics  # build and test one model
dbt build --select +fct_nutrition    # a model and everything upstream of it
dbt test                             # run tests only
dbt test --select source:raw         # test the raw source tables only
```

### Step 3: Explore the results

```sql
SELECT age_group, sex, COUNT(*) AS respondents
FROM HEALTH_PILLARS.MARTS.DIM_RESPONDENT
GROUP BY age_group, sex
ORDER BY MIN(age), sex;

SELECT d.age_group, ROUND(AVG(f.kcal)) AS avg_daily_kcal
FROM HEALTH_PILLARS.MARTS.FCT_NUTRITION f
JOIN HEALTH_PILLARS.MARTS.DIM_RESPONDENT d USING (respondent_id)
WHERE f.data_availability <> 'No data'
GROUP BY d.age_group
ORDER BY MIN(d.age);
```

Column names and descriptions are in [fct_nutrition.yml](dbt/models/marts/fct_nutrition.yml).

To browse the generated documentation and lineage graph:

```bash
cd dbt
dbt docs generate && dbt docs serve
```

### Project layout

```
scripts/            Python ingestion (NHANES → Snowflake RAW)
dbt/
  models/staging/   Sources, stg_demographics, stg_nutrition (views)
  models/marts/     dim_respondent, fct_nutrition (tables)
  macros/           sum_or_null, avg_or_null, value_between test, schema-name override
airflow/            Placeholder for orchestration (planned)
.github/workflows/  Placeholder for CI/CD (planned)
```

### Data source

Data comes from the CDC National Center for Health Statistics [NHANES](https://www.cdc.gov/nchs/nhanes/), which is public-use and de-identified.