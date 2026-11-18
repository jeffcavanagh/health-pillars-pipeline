# 0010: Respondent dimension design

Status: Accepted (2026-11)

Context: dim_respondent is the dimension every fact table joins to, so
its key and attribute design affect the whole model.

Decision: The key is the NHANES respondent number (SEQN, exposed as
respondent_id) and no surrogate key is added, since it is unique across
the cycles loaded. The mart keeps decoded labels (sex, race_ethnicity,
family_income) and drops the numeric code columns that exist in
staging. An age_group attribute bands age into 0-5, 6-12, 13-18,
19-25, 26-29, 30-39, 40-49, 50-59, 60-69, 70-79, and 80+. Top-coded
flags are retained (see 0006).

Consequences: Analysts group and filter on readable labels, and the
raw numeric age remains available. A new NHANES cycle fits the same
key. If respondent numbers ever collided across sources, a surrogate
key would be needed. The 80+ band is the top-coded group, so it
cannot be split further.