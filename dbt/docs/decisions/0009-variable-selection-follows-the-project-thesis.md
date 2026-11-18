# 0009: Variable selection follows the project thesis

Status: Accepted (2026-11)

Context: NHANES files contain hundreds of variables, many of them
excellent but unrelated to the question the project asks.

Decision: A variable is kept only if it relates to sleep, activity,
nutrition, or their health outcomes, is not redundant with a measured
value already kept, and is not methodological metadata. Examples:
- Folate is taken as dietary folate equivalents only. Food folate,
  folic acid, and total folate are not kept because DFE is the
  bioavailability-adjusted form.
- Vitamin E is total alpha-tocopherol only. The "added" variable is a
  subset of the total and would double count.
- Individual fatty acids are limited to EPA, DHA, and linoleic acid,
  the inputs to the omega ratio. Other chain-length variables are
  skipped, and saturated, monounsaturated, and polyunsaturated totals
  are kept.
- Recall-comparison, shellfish and fish flags (lab covariates), and
  salt-behavior questions are excluded. Measured sodium covers the last.
- Dental, environmental exposure, and infectious disease files are out
  of scope.
- Sample weight columns are not carried (see 0001).

Consequences: The model is smaller and every column has a stated
reason to exist. Some real signals are absent, notably ALA
omega-3 and supplement omega-3 products, which NHANES does not track.
Anything excluded can be added later from the raw tables.