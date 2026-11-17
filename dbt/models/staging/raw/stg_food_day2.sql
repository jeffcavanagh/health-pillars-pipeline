with source as (
    select * from {{ source('raw', 'DR2TOT_G') }}
),

renamed as (
    select
        cast(SEQN as integer) as respondent_id,

        DR2TKCAL as kcal,
        DR2TPROT as protein,
        DR2TCARB as carbs,
        DR2TTFAT as fat,
        DR2TSUGR as sugar,
        DR2TFIBE as fiber,
        DR2TSFAT as fat_saturated,
        DR2TMFAT as fat_monounsaturated,
        DR2TPFAT as fat_polyunsaturated,
        DR2TP182 as omega6,
        DR2TP205 as omega3_epa,
        DR2TP226 as omega3_dha,
        DR2TCHOL as cholesterol,
        DR2TATOC as vitamin_e,
        DR2TRET as retinol,
        DR2TVARA as vitamin_a,
        DR2TACAR as alpha_carotene,
        DR2TBCAR as beta_carotene,
        DR2TCRYP as beta_cryptoxanthin,
        DR2TLYCO as lycopene,
        DR2TLZ as lutein_zeaxanthin,
        DR2TVB1 as vitamin_b1,
        DR2TVB2 as vitamin_b2,
        DR2TNIAC as vitamin_b3,
        DR2TVB6 as vitamin_b6,
        DR2TFDFE as folate_dfe,
        DR2TCHL as choline,
        DR2TVB12 as vitamin_b12,
        DR2TVC as vitamin_c,
        DR2TVD as vitamin_d,
        DR2TVK as vitamin_k,
        DR2TCALC as calcium,
        DR2TPHOS as phosphorus,
        DR2TMAGN as magnesium,
        DR2TIRON as iron,
        DR2TZINC as zinc,
        DR2TCOPP as copper,
        DR2TSODI as sodium,
        DR2TPOTA as potassium,
        DR2TCAFF as caffeine,
        DR2TSELE as selenium,
        DR2TTHEO as theobromine,
        DR2TALCO as alcohol,
        DR2_320Z as water,

        case
            when DR2DRSTZ = 1 then true
            else false
        end as has_reliable_data

    from source
)

select * from renamed
