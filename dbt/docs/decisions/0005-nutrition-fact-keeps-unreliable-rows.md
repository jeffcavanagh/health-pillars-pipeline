# 0005: The nutrition fact table keeps unreliable rows and omits respondents with no dietary record

Status: Accepted (2026-11)

Context: dim_respondent covers all 9,756 NHANES respondents in the
demographics file. The dietary file has 9,338, because not everyone
completed the dietary component.

Decision: fct_nutrition has one row per respondent present in the
dietary files, including those labeled 'No data'. Respondents with no
dietary record at all are not padded into the fact table.

Consequences: Row counts reconcile with the raw dietary file.
Analysts who need every respondent should left join from
dim_respondent and treat missing nutrition as "no dietary data". The
relationship test runs one way only: every fact respondent must exist
in the dimension, but not the reverse.