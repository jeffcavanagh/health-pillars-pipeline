# 0003: Usual intake is the average of available recall days

Status: Accepted (2026-11)

Context: A single 24-hour recall is a noisy estimate of what someone
usually eats. NHANES collects two recall days, but not every respondent
completed both.

Decision: Each nutrient is the mean of day 1 and day 2 when both exist.
When only one day has a value, that day is used as is. A
data_availability column ('Both days', 'Day 1 only', 'Day 2 only',
'No data') records which case applies.

Consequences: Every respondent with any data gets an estimate, but
single-day estimates are less stable than two-day averages. Anyone
analyzing the data should filter or stratify on data_availability.
This is a simple average, not the statistical usual-intake modeling
NHANES researchers sometimes use. The avg_or_null macro holds the logic.