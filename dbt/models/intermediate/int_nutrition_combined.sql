with food_day1 as (
    select * from {{ ref('stg_food_day1') }}
),

supplements_day1 as (
    select * from {{ ref('stg_supplements_day1') }}
),

food_day2 as (
    select * from {{ ref('stg_food_day2') }}
),

supplements_day2 as (
    select * from {{ ref('stg_supplements_day2') }}
),

-- Day 1: add food and supplement intake. Not every respondent took supplements,
-- so supplements are left joined and nutrients found in both use sum_or_null.
day1 as (
    select
        f.respondent_id,

        {{ sum_or_null('f.kcal', 's.kcal') }} as kcal,
        {{ sum_or_null('f.protein', 's.protein') }} as protein,
        {{ sum_or_null('f.carbs', 's.carbs') }} as carbs,
        {{ sum_or_null('f.fat', 's.fat') }} as fat,
        {{ sum_or_null('f.sugar', 's.sugar') }} as sugar,
        {{ sum_or_null('f.fiber', 's.fiber') }} as fiber,
        {{ sum_or_null('f.fat_saturated', 's.fat_saturated') }} as fat_saturated,
        {{ sum_or_null('f.fat_monounsaturated', 's.fat_monounsaturated') }} as fat_monounsaturated,
        {{ sum_or_null('f.fat_polyunsaturated', 's.fat_polyunsaturated') }} as fat_polyunsaturated,
        f.omega6,
        f.omega3_epa,
        f.omega3_dha,
        {{ sum_or_null('f.cholesterol', 's.cholesterol') }} as cholesterol,
        f.vitamin_e,
        f.retinol,
        f.vitamin_a,
        f.alpha_carotene,
        f.beta_carotene,
        f.beta_cryptoxanthin,
        {{ sum_or_null('f.lycopene', 's.lycopene') }} as lycopene,
        {{ sum_or_null('f.lutein_zeaxanthin', 's.lutein_zeaxanthin') }} as lutein_zeaxanthin,
        {{ sum_or_null('f.vitamin_b1', 's.vitamin_b1') }} as vitamin_b1,
        {{ sum_or_null('f.vitamin_b2', 's.vitamin_b2') }} as vitamin_b2,
        {{ sum_or_null('f.vitamin_b3', 's.vitamin_b3') }} as vitamin_b3,
        {{ sum_or_null('f.vitamin_b6', 's.vitamin_b6') }} as vitamin_b6,
        {{ sum_or_null('f.folate_dfe', 's.folate_dfe') }} as folate_dfe,
        {{ sum_or_null('f.choline', 's.choline') }} as choline,
        {{ sum_or_null('f.vitamin_b12', 's.vitamin_b12') }} as vitamin_b12,
        {{ sum_or_null('f.vitamin_c', 's.vitamin_c') }} as vitamin_c,
        {{ sum_or_null('f.vitamin_d', 's.vitamin_d') }} as vitamin_d,
        {{ sum_or_null('f.vitamin_k', 's.vitamin_k') }} as vitamin_k,
        {{ sum_or_null('f.calcium', 's.calcium') }} as calcium,
        {{ sum_or_null('f.phosphorus', 's.phosphorus') }} as phosphorus,
        {{ sum_or_null('f.magnesium', 's.magnesium') }} as magnesium,
        {{ sum_or_null('f.iron', 's.iron') }} as iron,
        {{ sum_or_null('f.zinc', 's.zinc') }} as zinc,
        {{ sum_or_null('f.copper', 's.copper') }} as copper,
        {{ sum_or_null('f.sodium', 's.sodium') }} as sodium,
        {{ sum_or_null('f.potassium', 's.potassium') }} as potassium,
        {{ sum_or_null('f.caffeine', 's.caffeine') }} as caffeine,
        {{ sum_or_null('f.selenium', 's.selenium') }} as selenium,
        s.iodine,
        f.theobromine,
        f.alcohol,
        f.water,

        f.has_reliable_data

    from food_day1 f
    left join supplements_day1 s
        on f.respondent_id = s.respondent_id
),

-- Day 2: same logic as day 1.
day2 as (
    select
        f.respondent_id,

        {{ sum_or_null('f.kcal', 's.kcal') }} as kcal,
        {{ sum_or_null('f.protein', 's.protein') }} as protein,
        {{ sum_or_null('f.carbs', 's.carbs') }} as carbs,
        {{ sum_or_null('f.fat', 's.fat') }} as fat,
        {{ sum_or_null('f.sugar', 's.sugar') }} as sugar,
        {{ sum_or_null('f.fiber', 's.fiber') }} as fiber,
        {{ sum_or_null('f.fat_saturated', 's.fat_saturated') }} as fat_saturated,
        {{ sum_or_null('f.fat_monounsaturated', 's.fat_monounsaturated') }} as fat_monounsaturated,
        {{ sum_or_null('f.fat_polyunsaturated', 's.fat_polyunsaturated') }} as fat_polyunsaturated,
        f.omega6,
        f.omega3_epa,
        f.omega3_dha,
        {{ sum_or_null('f.cholesterol', 's.cholesterol') }} as cholesterol,
        f.vitamin_e,
        f.retinol,
        f.vitamin_a,
        f.alpha_carotene,
        f.beta_carotene,
        f.beta_cryptoxanthin,
        {{ sum_or_null('f.lycopene', 's.lycopene') }} as lycopene,
        {{ sum_or_null('f.lutein_zeaxanthin', 's.lutein_zeaxanthin') }} as lutein_zeaxanthin,
        {{ sum_or_null('f.vitamin_b1', 's.vitamin_b1') }} as vitamin_b1,
        {{ sum_or_null('f.vitamin_b2', 's.vitamin_b2') }} as vitamin_b2,
        {{ sum_or_null('f.vitamin_b3', 's.vitamin_b3') }} as vitamin_b3,
        {{ sum_or_null('f.vitamin_b6', 's.vitamin_b6') }} as vitamin_b6,
        {{ sum_or_null('f.folate_dfe', 's.folate_dfe') }} as folate_dfe,
        {{ sum_or_null('f.choline', 's.choline') }} as choline,
        {{ sum_or_null('f.vitamin_b12', 's.vitamin_b12') }} as vitamin_b12,
        {{ sum_or_null('f.vitamin_c', 's.vitamin_c') }} as vitamin_c,
        {{ sum_or_null('f.vitamin_d', 's.vitamin_d') }} as vitamin_d,
        {{ sum_or_null('f.vitamin_k', 's.vitamin_k') }} as vitamin_k,
        {{ sum_or_null('f.calcium', 's.calcium') }} as calcium,
        {{ sum_or_null('f.phosphorus', 's.phosphorus') }} as phosphorus,
        {{ sum_or_null('f.magnesium', 's.magnesium') }} as magnesium,
        {{ sum_or_null('f.iron', 's.iron') }} as iron,
        {{ sum_or_null('f.zinc', 's.zinc') }} as zinc,
        {{ sum_or_null('f.copper', 's.copper') }} as copper,
        {{ sum_or_null('f.sodium', 's.sodium') }} as sodium,
        {{ sum_or_null('f.potassium', 's.potassium') }} as potassium,
        {{ sum_or_null('f.caffeine', 's.caffeine') }} as caffeine,
        {{ sum_or_null('f.selenium', 's.selenium') }} as selenium,
        s.iodine,
        f.theobromine,
        f.alcohol,
        f.water,

        f.has_reliable_data

    from food_day2 f
    left join supplements_day2 s
        on f.respondent_id = s.respondent_id
),

-- Average the two days. avg_or_null uses the one available day when the other is missing.
averaged as (
    select
        d1.respondent_id,

        case
            when d1.has_reliable_data and d2.has_reliable_data then 'Both days'
            when d1.has_reliable_data then 'Day 1 only'
            when d2.has_reliable_data then 'Day 2 only'
            else 'No data'
        end as data_availability,

        {{ avg_or_null('d1.kcal', 'd2.kcal') }} as tkcal_avg,
        {{ avg_or_null('d1.protein', 'd2.protein') }} as tprot_avg,
        {{ avg_or_null('d1.carbs', 'd2.carbs') }} as tcarb_avg,
        {{ avg_or_null('d1.fat', 'd2.fat') }} as tfat_avg,
        {{ avg_or_null('d1.sugar', 'd2.sugar') }} as tsugar_avg,
        {{ avg_or_null('d1.fiber', 'd2.fiber') }} as tfiber_avg,
        {{ avg_or_null('d1.fat_saturated', 'd2.fat_saturated') }} as tsatfat_avg,
        {{ avg_or_null('d1.fat_monounsaturated', 'd2.fat_monounsaturated') }} as tmonofat_avg,
        {{ avg_or_null('d1.fat_polyunsaturated', 'd2.fat_polyunsaturated') }} as tpolyfat_avg,
        {{ avg_or_null('d1.omega6', 'd2.omega6') }} as tomega6_avg,
        {{ avg_or_null('d1.omega3_epa', 'd2.omega3_epa') }} as tomega3epa_avg,
        {{ avg_or_null('d1.omega3_dha', 'd2.omega3_dha') }} as tomega3dha_avg,
        {{ avg_or_null('d1.cholesterol', 'd2.cholesterol') }} as tchol_avg,
        {{ avg_or_null('d1.vitamin_e', 'd2.vitamin_e') }} as tvitaminE_avg,
        {{ avg_or_null('d1.retinol', 'd2.retinol') }} as tretinol_avg,
        {{ avg_or_null('d1.vitamin_a', 'd2.vitamin_a') }} as tvitaminA_avg,
        {{ avg_or_null('d1.alpha_carotene', 'd2.alpha_carotene') }} as talpha_carotene_avg,
        {{ avg_or_null('d1.beta_carotene', 'd2.beta_carotene') }} as tbeta_carotene_avg,
        {{ avg_or_null('d1.beta_cryptoxanthin', 'd2.beta_cryptoxanthin') }} as tbeta_cryptoxanthin_avg,
        {{ avg_or_null('d1.lycopene', 'd2.lycopene') }} as tlycopene_avg,
        {{ avg_or_null('d1.lutein_zeaxanthin', 'd2.lutein_zeaxanthin') }} as tlutein_zeaxanthin_avg,
        {{ avg_or_null('d1.vitamin_b1', 'd2.vitamin_b1') }} as tvitaminB1_avg,
        {{ avg_or_null('d1.vitamin_b2', 'd2.vitamin_b2') }} as tvitaminB2_avg,
        {{ avg_or_null('d1.vitamin_b3', 'd2.vitamin_b3') }} as tvitaminB3_avg,
        {{ avg_or_null('d1.vitamin_b6', 'd2.vitamin_b6') }} as tvitaminB6_avg,
        {{ avg_or_null('d1.folate_dfe', 'd2.folate_dfe') }} as tfolate_dfe_avg,
        {{ avg_or_null('d1.choline', 'd2.choline') }} as tcholine_avg,
        {{ avg_or_null('d1.vitamin_b12', 'd2.vitamin_b12') }} as tvitaminB12_avg,
        {{ avg_or_null('d1.vitamin_c', 'd2.vitamin_c') }} as tvitaminC_avg,
        {{ avg_or_null('d1.vitamin_d', 'd2.vitamin_d') }} as tvitaminD_avg,
        {{ avg_or_null('d1.vitamin_k', 'd2.vitamin_k') }} as tvitaminK_avg,
        {{ avg_or_null('d1.calcium', 'd2.calcium') }} as tcalcium_avg,
        {{ avg_or_null('d1.phosphorus', 'd2.phosphorus') }} as tphosphorus_avg,
        {{ avg_or_null('d1.magnesium', 'd2.magnesium') }} as tmagnesium_avg,
        {{ avg_or_null('d1.iron', 'd2.iron') }} as tiron_avg,
        {{ avg_or_null('d1.zinc', 'd2.zinc') }} as tzinc_avg,
        {{ avg_or_null('d1.copper', 'd2.copper') }} as tcopper_avg,
        {{ avg_or_null('d1.sodium', 'd2.sodium') }} as tsodium_avg,
        {{ avg_or_null('d1.potassium', 'd2.potassium') }} as tpotassium_avg,
        {{ avg_or_null('d1.caffeine', 'd2.caffeine') }} as tcaffeine_avg,
        {{ avg_or_null('d1.selenium', 'd2.selenium') }} as tselenium_avg,
        {{ avg_or_null('d1.iodine', 'd2.iodine') }} as tiodine_avg,
        {{ avg_or_null('d1.theobromine', 'd2.theobromine') }} as ttheobromine_avg,
        {{ avg_or_null('d1.alcohol', 'd2.alcohol') }} as talcohol_avg,
        {{ avg_or_null('d1.water', 'd2.water') }} as twater_avg

    from day1 d1
    left join day2 d2
        on d1.respondent_id = d2.respondent_id
)

select * from averaged
