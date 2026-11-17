with source as (
    select * from {{ source('raw', 'DS1TOT_G') }}
),

renamed as (
    select
        cast(SEQN as integer) as respondent_id,

        DS1TKCAL as kcal,
        DS1TPROT as protein,
        DS1TCARB as carbs,
        DS1TTFAT as fat,
        DS1TSUGR as sugar,
        DS1TFIBE as fiber,
        DS1TSFAT as fat_saturated,
        DS1TMFAT as fat_monounsaturated,
        DS1TPFAT as fat_polyunsaturated,
        DS1TCHOL as cholesterol,
        DS1TLYCO as lycopene,
        DS1TLZ as lutein_zeaxanthin,
        DS1TVB1 as vitamin_b1,
        DS1TVB2 as vitamin_b2,
        DS1TNIAC as vitamin_b3,
        DS1TVB6 as vitamin_b6,
        DS1TFDFE as folate_dfe,
        DS1TCHL as choline,
        DS1TVB12 as vitamin_b12,
        DS1TVC as vitamin_c,
        DS1TVD as vitamin_d,
        DS1TVK as vitamin_k,
        DS1TCALC as calcium,
        DS1TPHOS as phosphorus,
        DS1TMAGN as magnesium,
        DS1TIRON as iron,
        DS1TZINC as zinc,
        DS1TCOPP as copper,
        DS1TSODI as sodium,
        DS1TPOTA as potassium,
        DS1TCAFF as caffeine,
        DS1TSELE as selenium,
        DS1TIODI as iodine

    from source
)

select * from renamed
