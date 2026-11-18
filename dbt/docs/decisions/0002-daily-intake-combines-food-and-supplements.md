# 0002: Daily intake combines food and supplements

Status: Accepted (2026-11)

Context: NHANES records dietary intake in separate food and supplement
files for each recall day. Most respondents have no supplement record,
and a missing supplement record means "took none", not "unknown".

Decision: For each recall day, food and supplement values are summed
for every nutrient that appears in both files. The food file is the
anchor and supplements are left joined. The sum is null only when both
values are null. Nutrients with no supplement counterpart in NHANES
(for example EPA and DHA) come from the food file alone.

Consequences: Respondents without supplements keep their full food
intake. A plain addition would have nulled their totals, because NULL
plus a number is NULL. The null-aware logic lives in the sum_or_null
macro so the rule is defined once.