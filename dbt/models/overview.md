{% docs __overview__ %}

# health-pillars-pipeline

NHANES 2011-2012 demographics and dietary data, modeled in Snowflake with dbt.

**Environments:** the `prod` target builds into the `HEALTH_PILLARS` database using the schema names below.

**Layers :**

| Schema | Materialization | Contents |
|---|---|---|
| `RAW` | Tables (loaded by Python scripts, not dbt) | As-loaded NHANES files: `DEMO_G`, `DR1TOT_G`, `DR2TOT_G`, `DS1TOT_G`, `DS2TOT_G`. Source freshness warns after 180 days. |
| `STAGING` | Views | Cleaned, renamed and decoded models: `stg_demographics`, `stg_food_day1`, `stg_food_day2`, `stg_supplements_day1`, `stg_supplements_day2`. |
| `INTERMEDIATE` | Views | `int_nutrition_combined` combines food and supplement intake for both recall days and averages nutrients across the two days. |
| `MARTS` | Tables | `dim_respondent` and `fct_nutrition`. |

**Grain:** `dim_respondent` has one row per NHANES respondent. `fct_nutrition` has one row per respondent with a dietary record, representing an average day of nutrient consumption.

**Testing:** `unique`, `not_null` and `accepted_values` tests on sources and models, plus the custom `value_between` generic test for nutrient range checks.

**Known limitations:** survey weights are not applied, so results describe the sample and not the US population (see decision 0001 in `dbt/docs/decisions`). Respondents without dietary records are absent from the fact table, so left join from the dimension when you need everyone. Only the 2011-2012 cycle is loaded, and no health outcome data is modeled yet.

{% enddocs %}