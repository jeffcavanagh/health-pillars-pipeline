with source as (
    select * from {{ source('raw', 'DS2TOT_G') }}
),

renamed as (
    select
        cast(SEQN as integer) as respondent_id,

        DS2TKCAL as kcal,
        DS2TPROT as protein,
        DS2TCARB as carbs,
        DS2TTFAT as fat,
        DS2TSUGR as sugar,
        DS2TFIBE as fiber,
        DS2TSFAT as fat_saturated,
        DS2TMFAT as fat_monounsaturated,
        DS2TPFAT as fat_polyunsaturated,
        DS2TCHOL as cholesterol,
        DS2TLYCO as lycopene,
        DS2TLZ as lutein_zeaxanthin,
        DS2TVB1 as vitamin_b1,
        DS2TVB2 as vitamin_b2,
        DS2TNIAC as vitamin_b3,
        DS2TVB6 as vitamin_b6,
        DS2TFDFE as folate_dfe,
        DS2TCHL as choline,
        DS2TVB12 as vitamin_b12,
        DS2TVC as vitamin_c,
        DS2TVD as vitamin_d,
        DS2TVK as vitamin_k,
        DS2TCALC as calcium,
        DS2TPHOS as phosphorus,
        DS2TMAGN as magnesium,
        DS2TIRON as iron,
        DS2TZINC as zinc,
        DS2TCOPP as copper,
        DS2TSODI as sodium,
        DS2TPOTA as potassium,
        DS2TCAFF as caffeine,
        DS2TSELE as selenium,
        DS2TIODI as iodine

    from source
)

select * from renamed
