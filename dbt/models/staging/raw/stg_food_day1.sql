with source as (
    select * from {{ source('raw', 'DR1TOT_G') }}
),

renamed as (
    select
        cast(SEQN as integer) as respondent_id,

        DR1TKCAL as kcal,
        DR1TPROT as protein,
        DR1TCARB as carbs,
        DR1TTFAT as fat,
        DR1TSUGR as sugar,
        DR1TFIBE as fiber,
        DR1TSFAT as fat_saturated,
        DR1TMFAT as fat_monounsaturated,
        DR1TPFAT as fat_polyunsaturated,
        DR1TP182 as omega6,
        DR1TP205 as omega3_epa,
        DR1TP226 as omega3_dha,
        DR1TCHOL as cholesterol,
        DR1TATOC as vitamin_e,
        DR1TRET as retinol,
        DR1TVARA as vitamin_a,
        DR1TACAR as alpha_carotene,
        DR1TBCAR as beta_carotene,
        DR1TCRYP as beta_cryptoxanthin,
        DR1TLYCO as lycopene,
        DR1TLZ as lutein_zeaxanthin,
        DR1TVB1 as vitamin_b1,
        DR1TVB2 as vitamin_b2,
        DR1TNIAC as vitamin_b3,
        DR1TVB6 as vitamin_b6,
        DR1TFDFE as folate_dfe,
        DR1TCHL as choline,
        DR1TVB12 as vitamin_b12,
        DR1TVC as vitamin_c,
        DR1TVD as vitamin_d,
        DR1TVK as vitamin_k,
        DR1TCALC as calcium,
        DR1TPHOS as phosphorus,
        DR1TMAGN as magnesium,
        DR1TIRON as iron,
        DR1TZINC as zinc,
        DR1TCOPP as copper,
        DR1TSODI as sodium,
        DR1TPOTA as potassium,
        DR1TCAFF as caffeine,
        DR1TSELE as selenium,
        DR1TTHEO as theobromine,
        DR1TALCO as alcohol,
        DR1_320Z as water,

        case
            when DR1DRSTZ = 1 then true
            else false
        end as has_reliable_data

    from source
)

select * from renamed
