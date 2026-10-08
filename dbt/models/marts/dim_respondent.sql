SELECT 
    respondent_id,
    survey_year,
    sex,
    age_years as age,
    case
        when age_years < 6 then '0-5'
        when age_years < 13 then '6-12'
        when age_years < 18 then '13-17'
        when age_years < 26 then '18-25'
        when age_years < 30 then '26-29'
        when age_years < 40 then '30-39'
        when age_years < 50 then '40-49'
        when age_years < 60 then '50-59'
        when age_years < 70 then '60-69'
        when age_years < 80 then '70-79'
        else '80+'
    end as age_group,
    is_age_topcoded,
    race_ethnicity,
    family_income,
    income_poverty_ratio,
    is_income_ratio_topcoded,
    family_size,
    is_family_size_topcoded
FROM {{ ref('stg_demographics') }}