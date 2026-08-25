with source as (
    select * from {{ source('raw', 'DEMO_G') }}
),

renamed as (
    select 
        cast(SEQN as integer) as respondent_id,

        cast(SDDSRVYR as integer) as survey_year_code,
        case
            when SDDSRVYR = 1 then '1999-2000'
            when SDDSRVYR = 2 then '2001-2002'
            when SDDSRVYR = 3 then '2003-2004'
            when SDDSRVYR = 4 then '2005-2006'
            when SDDSRVYR = 5 then '2007-2008'
            when SDDSRVYR = 6 then '2009-2010'
            when SDDSRVYR = 7 then '2011-2012'
            when SDDSRVYR = 8 then '2013-2014'
            when SDDSRVYR = 9 then '2015-2016'
            when SDDSRVYR = 10 then '2017-2018'
        end as survey_year,

        cast(RIAGENDR as integer) as sex_code,
        case
            when RIAGENDR = 1 then 'Male'
            when RIAGENDR = 2 then 'Female'
        end as sex,

        cast(RIDAGEYR as integer) as age_years,
        case
            when RIDAGEYR = 80 then true
            else false
        end as is_age_topcoded,

        cast(RIDRETH3 as integer) as race_ethnicity_code,
        case
            when RIDRETH3 = 1 then 'Mexican American'
            when RIDRETH3 = 2 then 'Other Hispanic'
            when RIDRETH3 = 3 then 'Non-Hispanic White'
            when RIDRETH3 = 4 then 'Non-Hispanic Black'
            when RIDRETH3 = 6 then 'Non-Hispanic Asian'
            when RIDRETH3 = 7 then 'Other Race - Including Multi-Racial'
        end as race_ethnicity,

        cast(INDFMIN2 as integer) as family_income_code,
        case
            when INDFMIN2 = 1 then '<$0 - $4,999>'
            when INDFMIN2 = 2 then '$5,000 - $9,999'
            when INDFMIN2 = 3 then '$10,000 - $14,999'
            when INDFMIN2 = 4 then '$15,000 - $19,999'
            when INDFMIN2 = 5 then '$20,000 - $24,999'
            when INDFMIN2 = 6 then '$25,000 - $34,999'
            when INDFMIN2 = 7 then '$35,000 - $44,999'
            when INDFMIN2 = 8 then '$45,000 - $54,999'
            when INDFMIN2 = 9 then '$55,000 - $64,999'
            when INDFMIN2 = 10 then '$65,000 - $74,999'
            when INDFMIN2 = 12 then '$20,000 and Over'
            when INDFMIN2 = 13 then 'Under $20,000'
            when INDFMIN2 = 14 then '$75,000 - $99,999'
            when INDFMIN2 = 15 then '$100,000 and Over'
            when INDFMIN2 = 77 then 'Refused'
            when INDFMIN2 = 99 then 'Unknown'
            else 'Unknown'
        end as family_income,

        INDFMPIR as income_poverty_ratio,
        case
            when INDFMPIR = 5 then true
            else false
        end as is_income_ratio_topcoded,

        cast(DMDFMSIZ as integer) as family_size

    from source
    
)

select * from renamed