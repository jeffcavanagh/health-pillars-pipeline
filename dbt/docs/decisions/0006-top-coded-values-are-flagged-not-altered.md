# 0006: Top-coded values are flagged, not altered

Status: Accepted (2026-11)

Context: NHANES caps some variables to protect privacy. Age is coded
as 80 for everyone 80 and older, the income-to-poverty ratio is capped
at 5, and family size is capped at 7. A capped value is a floor, not an
exact measurement.

Decision: Values are kept as delivered. A boolean flag column marks
each capped variable (is_age_topcoded, is_income_ratio_topcoded,
is_family_size_topcoded).

Consequences: Nothing is imputed or hidden, and analysts can exclude
or handle capped rows deliberately. Averages and correlations on these
variables are biased at the top end, and the flags are the way to
account for that.