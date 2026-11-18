# 0004: Recall reliability comes from the NHANES status code

Status: Accepted (2026-11)

Context: Whether a day's recall is usable could be inferred from null
calories, or taken from the NHANES recall status variable (DR1DRSTZ,
DR2DRSTZ). The status codes are: 1 reliable, 2 not reliable,
4 breast-fed infant, 5 not done.

Decision: A day counts as reliable only when its status code is 1.
Codes 2, 4, and 5 are all treated as not reliable. Breast-fed infants
(code 4) are collapsed into this group because infant feeding is
outside the project's scope and those records hold no nutrient data.

Consequences: The flag follows NHANES's own judgment, not a proxy. It
also exposed an edge case: two respondents labeled 'No data' still
carry trace values (for example 8 and 12.5 kcal). The flag labels rows
but does not filter nutrient values, so those trace values reach the
averages. A consistency test asserting that 'No data' means all-null
nutrients was removed for this reason.