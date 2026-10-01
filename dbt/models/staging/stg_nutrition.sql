with dr1tot as (
    select * from {{ source('raw', 'DR1TOT_G') }}
),

ds1tot as (
    select * from {{ source('raw', 'DS1TOT_G') }}
),

d1tot_comb as (
    select 
        f.SEQN as respondent_id,
        -- fact details from each data set
        {{ sum_or_null('f.DR1TKCAL', 's.DS1TKCAL')}} as d1tkcal,
        -- f.DR1TKCAL as dr1tkcal,
        -- s.DS1TKCAL as ds1tkcal,
        {{ sum_or_null('f.DR1TPROT', 's.DS1TPROT')}} as d1tprot,
        {{ sum_or_null('f.DR1TCARB', 's.DS1TCARB')}} as d1tcarb,
        {{ sum_or_null('f.DR1TTFAT', 's.DS1TTFAT')}} as d1tfat,
        {{ sum_or_null('f.DR1TSUGR', 's.DS1TSUGR')}} as d1tsugar,
        {{ sum_or_null('f.DR1TFIBE', 's.DS1TFIBE')}} as d1tfiber,
        {{ sum_or_null('f.DR1TSFAT', 's.DS1TSFAT')}} as d1tsatfat,
        {{ sum_or_null('f.DR1TMFAT', 's.DS1TMFAT')}} as d1tmonofat,
        {{ sum_or_null('f.DR1TPFAT', 's.DS1TPFAT')}} as d1tpolyfat,
        f.DR1TP182 as d1tomega6,
        f.DR1TP205 as d1tomega3epa,
        f.DR1TP226 as d1tomega3dha,
        {{ sum_or_null('f.DR1TCHOL', 's.DS1TCHOL')}} as d1tchol,
        f.DR1TATOC as d1tvitaminE,
        f.DR1TRET as d1tretinol,
        f.DR1TVARA as d1tvitaminA,
        f.DR1TACAR as d1talpha_carotene,
        f.DR1TBCAR as d1tbeta_carotene,
        f.DR1TCRYP as d1tbeta_cryptoxanthin,
        {{ sum_or_null('f.DR1TLYCO', 's.DS1TLYCO')}} as d1tlycopene,
        {{ sum_or_null('f.DR1TLZ', 's.DS1TLZ')}} as d1tlutein_zeaxanthin,
        {{ sum_or_null('f.DR1TVB1', 's.DS1TVB1')}} as d1tvitaminB1,
        {{ sum_or_null('f.DR1TVB2', 's.DS1TVB2')}} as d1tvitaminB2,
        {{ sum_or_null('f.DR1TNIAC', 's.DS1TNIAC')}} as d1tvitaminB3,
        {{ sum_or_null('f.DR1TVB6', 's.DS1TVB6')}} as d1tvitaminB6,
        {{ sum_or_null('f.DR1TFDFE', 's.DS1TFDFE') }} as d1tfolate_dfe,
        {{ sum_or_null('f.DR1TCHL', 's.DS1TCHL') }} as d1tcholine,
        {{ sum_or_null('f.DR1TVB12', 's.DS1TVB12') }} as d1tvitaminB12,
        {{ sum_or_null('f.DR1TVC', 's.DS1TVC') }} as d1tvitaminC,
        {{ sum_or_null('f.DR1TVD', 's.DS1TVD') }} as d1tvitaminD,
        {{ sum_or_null('f.DR1TVK', 's.DS1TVK') }} as d1tvitaminK,
        {{ sum_or_null('f.DR1TCALC', 's.DS1TCALC') }} as d1tcalcium,
        {{ sum_or_null('f.DR1TPHOS', 's.DS1TPHOS') }} as d1tphosphorus,
        {{ sum_or_null('f.DR1TMAGN', 's.DS1TMAGN') }} as d1tmagnesium,
        {{ sum_or_null('f.DR1TIRON', 's.DS1TIRON') }} as d1tiron,
        {{ sum_or_null('f.DR1TZINC', 's.DS1TZINC') }} as d1tzinc,
        {{ sum_or_null('f.DR1TCOPP', 's.DS1TCOPP') }} as d1tcopper,
        {{ sum_or_null('f.DR1TSODI', 's.DS1TSODI') }} as d1tsodium,
        {{ sum_or_null('f.DR1TPOTA', 's.DS1TPOTA') }} as d1tpotassium,
        {{ sum_or_null('f.DR1TCAFF', 's.DS1TCAFF') }} as d1tcaffeine,
        {{ sum_or_null('f.DR1TSELE', 's.DS1TSELE') }} as d1tselenium,
        s.DS1TIODI as d1tiodine,
        f.DR1TTHEO as d1ttheobromine,
        f.DR1TALCO as d1talcohol,
        f.DR1_320Z as d1twater,

        -- dim details
        case
            when f.DR1DRSTZ = 1 then true
            else false
        end as d1_has_reliable_data
        


    from dr1tot f
    left join ds1tot s
        on f.SEQN = s.SEQN
),

dr2tot as (
    select * from {{ source('raw', 'DR2TOT_G') }}
),

ds2tot as (
    select * from {{ source('raw', 'DS2TOT_G') }}
),

d2tot_comb as (
    select 
        f.SEQN as respondent_id,
        -- fact details from each data set
        {{ sum_or_null('f.DR2TKCAL', 's.DS2TKCAL')}} as d2tkcal,
        {{ sum_or_null('f.DR2TPROT', 's.DS2TPROT')}} as d2tprot,
        {{ sum_or_null('f.DR2TCARB', 's.DS2TCARB')}} as d2tcarb,
        {{ sum_or_null('f.DR2TTFAT', 's.DS2TTFAT')}} as d2tfat,
        {{ sum_or_null('f.DR2TSUGR', 's.DS2TSUGR')}} as d2tsugar,
        {{ sum_or_null('f.DR2TFIBE', 's.DS2TFIBE')}} as d2tfiber,
        {{ sum_or_null('f.DR2TSFAT', 's.DS2TSFAT')}} as d2tsatfat,
        {{ sum_or_null('f.DR2TMFAT', 's.DS2TMFAT')}} as d2tmonofat,
        {{ sum_or_null('f.DR2TPFAT', 's.DS2TPFAT')}} as d2tpolyfat,
        f.DR2TP182 as d2tomega6,
        f.DR2TP205 as d2tomega3epa,
        f.DR2TP226 as d2tomega3dha,
        {{ sum_or_null('f.DR2TCHOL', 's.DS2TCHOL')}} as d2tchol,
        f.DR2TATOC as d2tvitaminE,
        f.DR2TRET as d2tretinol,
        f.DR2TVARA as d2tvitaminA,
        f.DR2TACAR as d2talpha_carotene,
        f.DR2TBCAR as d2tbeta_carotene,
        f.DR2TCRYP as d2tbeta_cryptoxanthin,
        {{ sum_or_null('f.DR2TLYCO', 's.DS2TLYCO')}} as d2tlycopene,
        {{ sum_or_null('f.DR2TLZ', 's.DS2TLZ')}} as d2tlutein_zeaxanthin,
        {{ sum_or_null('f.DR2TVB1', 's.DS2TVB1')}} as d2tvitaminB1,
        {{ sum_or_null('f.DR2TVB2', 's.DS2TVB2')}} as d2tvitaminB2,
        {{ sum_or_null('f.DR2TNIAC', 's.DS2TNIAC')}} as d2tvitaminB3,
        {{ sum_or_null('f.DR2TVB6', 's.DS2TVB6')}} as d2tvitaminB6,
        {{ sum_or_null('f.DR2TFDFE', 's.DS2TFDFE') }} as d2tfolate_dfe,
        {{ sum_or_null('f.DR2TCHL', 's.DS2TCHL') }} as d2tcholine,
        {{ sum_or_null('f.DR2TVB12', 's.DS2TVB12') }} as d2tvitaminB12,
        {{ sum_or_null('f.DR2TVC', 's.DS2TVC') }} as d2tvitaminC,
        {{ sum_or_null('f.DR2TVD', 's.DS2TVD') }} as d2tvitaminD,
        {{ sum_or_null('f.DR2TVK', 's.DS2TVK') }} as d2tvitaminK,
        {{ sum_or_null('f.DR2TCALC', 's.DS2TCALC') }} as d2tcalcium,
        {{ sum_or_null('f.DR2TPHOS', 's.DS2TPHOS') }} as d2tphosphorus,
        {{ sum_or_null('f.DR2TMAGN', 's.DS2TMAGN') }} as d2tmagnesium,
        {{ sum_or_null('f.DR2TIRON', 's.DS2TIRON') }} as d2tiron,
        {{ sum_or_null('f.DR2TZINC', 's.DS2TZINC') }} as d2tzinc,
        {{ sum_or_null('f.DR2TCOPP', 's.DS2TCOPP') }} as d2tcopper,
        {{ sum_or_null('f.DR2TSODI', 's.DS2TSODI') }} as d2tsodium,
        {{ sum_or_null('f.DR2TPOTA', 's.DS2TPOTA') }} as d2tpotassium,
        {{ sum_or_null('f.DR2TCAFF', 's.DS2TCAFF') }} as d2tcaffeine,
        {{ sum_or_null('f.DR2TSELE', 's.DS2TSELE') }} as d2tselenium,
        s.DS2TIODI as d2tiodine,
        f.DR2TTHEO as d2ttheobromine,
        f.DR2TALCO as d2talcohol,
        f.DR2_320Z as d2twater,

        -- dim details
        case
            when f.DR2DRSTZ = 1 then true
            else false
        end as d2_has_reliable_data


    from dr2tot f
    left join ds2tot s
        on f.SEQN = s.SEQN
),

tot_comb_avg as (
    select 
        d1.respondent_id,
        -- dim details
        case
            when d1.d1_has_reliable_data and d2.d2_has_reliable_data then 'Both days'
            when d1.d1_has_reliable_data then 'Day 1 only'
            when d2.d2_has_reliable_data then 'Day 2 only'
            else 'No data'
        end as data_availability,

        -- fact details
        {{ avg_or_null('d1.d1tkcal', 'd2.d2tkcal') }} as tkcal_avg,
        {{ avg_or_null('d1.d1tprot', 'd2.d2tprot') }} as tprot_avg,
        {{ avg_or_null('d1.d1tcarb', 'd2.d2tcarb') }} as tcarb_avg,
        {{ avg_or_null('d1.d1tfat', 'd2.d2tfat') }} as tfat_avg,
        {{ avg_or_null('d1.d1tsugar', 'd2.d2tsugar') }} as tsugar_avg,
        {{ avg_or_null('d1.d1tfiber', 'd2.d2tfiber') }} as tfiber_avg,
        {{ avg_or_null('d1.d1tsatfat', 'd2.d2tsatfat') }} as tsatfat_avg,
        {{ avg_or_null('d1.d1tmonofat', 'd2.d2tmonofat') }} as tmonofat_avg,
        {{ avg_or_null('d1.d1tpolyfat', 'd2.d2tpolyfat') }} as tpolyfat_avg,
        {{ avg_or_null('d1.d1tomega6', 'd2.d2tomega6') }} as tomega6_avg,
        {{ avg_or_null('d1.d1tomega3epa', 'd2.d2tomega3epa') }} as tomega3epa_avg,
        {{ avg_or_null('d1.d1tomega3dha', 'd2.d2tomega3dha') }} as tomega3dha_avg,
        {{ avg_or_null('d1.d1tchol', 'd2.d2tchol') }} as tchol_avg,
        {{ avg_or_null('d1.d1tvitaminE', 'd2.d2tvitaminE') }} as tvitaminE_avg,
        {{ avg_or_null('d1.d1tretinol', 'd2.d2tretinol') }} as tretinol_avg,
        {{ avg_or_null('d1.d1tvitaminA', 'd2.d2tvitaminA') }} as tvitaminA_avg,
        {{ avg_or_null('d1.d1talpha_carotene', 'd2.d2talpha_carotene') }} as talpha_carotene_avg,
        {{ avg_or_null('d1.d1tbeta_carotene', 'd2.d2tbeta_carotene') }} as tbeta_carotene_avg,
        {{ avg_or_null('d1.d1tbeta_cryptoxanthin', 'd2.d2tbeta_cryptoxanthin') }} as tbeta_cryptoxanthin_avg,
        {{ avg_or_null('d1.d1tlycopene', 'd2.d2tlycopene')}} as tlycopene_avg,
        {{ avg_or_null('d1.d1tlutein_zeaxanthin', 'd2.d2tlutein_zeaxanthin')}} as tlutein_zeaxanthin_avg,
        {{ avg_or_null('d1.d1tvitaminB1', 'd2.d2tvitaminB1')}} as tvitaminB1_avg,
        {{ avg_or_null('d1.d1tvitaminB2', 'd2.d2tvitaminB2')}} as tvitaminB2_avg,
        {{ avg_or_null('d1.d1tvitaminB3', 'd2.d2tvitaminB3')}} as tvitaminB3_avg,
        {{ avg_or_null('d1.d1tvitaminB6', 'd2.d2tvitaminB6')}} as tvitaminB6_avg,
        {{ avg_or_null('d1.d1tfolate_dfe', 'd2.d2tfolate_dfe') }} as tfolate_dfe_avg,
        {{ avg_or_null('d1.d1tcholine', 'd2.d2tcholine') }} as tcholine_avg,
        {{ avg_or_null('d1.d1tvitaminB12', 'd2.d2tvitaminB12') }} as tvitaminB12_avg,
        {{ avg_or_null('d1.d1tvitaminC', 'd2.d2tvitaminC') }} as tvitaminC_avg,
        {{ avg_or_null('d1.d1tvitaminD', 'd2.d2tvitaminD') }} as tvitaminD_avg,
        {{ avg_or_null('d1.d1tvitaminK', 'd2.d2tvitaminK') }} as tvitaminK_avg,
        {{ avg_or_null('d1.d1tcalcium', 'd2.d2tcalcium') }} as tcalcium_avg,
        {{ avg_or_null('d1.d1tphosphorus', 'd2.d2tphosphorus') }} as tphosphorus_avg,
        {{ avg_or_null('d1.d1tmagnesium', 'd2.d2tmagnesium') }} as tmagnesium_avg,
        {{ avg_or_null('d1.d1tiron', 'd2.d2tiron') }} as tiron_avg,
        {{ avg_or_null('d1.d1tzinc', 'd2.d2tzinc') }} as tzinc_avg,
        {{ avg_or_null('d1.d1tcopper', 'd2.d2tcopper') }} as tcopper_avg,
        {{ avg_or_null('d1.d1tsodium', 'd2.d2tsodium') }} as tsodium_avg,
        {{ avg_or_null('d1.d1tpotassium', 'd2.d2tpotassium') }} as tpotassium_avg,
        {{ avg_or_null('d1.d1tcaffeine', 'd2.d2tcaffeine') }} as tcaffeine_avg,
        {{ avg_or_null('d1.d1tselenium', 'd2.d2tselenium') }} as tselenium_avg,
        {{ avg_or_null('d1.d1tiodine', 'd2.d2tiodine') }} as tiodine_avg,
        {{ avg_or_null('d1.d1ttheobromine', 'd2.d2ttheobromine') }} as ttheobromine_avg,
        {{ avg_or_null('d1.d1talcohol', 'd2.d2talcohol') }} as talcohol_avg,
        {{ avg_or_null('d1.d1twater', 'd2.d2twater') }} as twater_avg

    from d1tot_comb d1
    left join d2tot_comb d2
        on d1.respondent_id = d2.respondent_id
)

select * from tot_comb_avg