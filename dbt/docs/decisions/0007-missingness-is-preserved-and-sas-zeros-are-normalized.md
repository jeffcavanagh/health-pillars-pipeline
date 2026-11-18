# 0007: Missingness is preserved, and SAS zeros are normalized at ingestion

Status: Accepted (2026-11)

Context: NHANES marks missing values in several ways. Some are true
missing values, some are survey codes such as 77 (refused) and
99 (don't know), and some columns are legitimately null for part of
the sample. Separately, the SAS reader in pandas decodes a stored zero
as a tiny float (about 5.4e-79) because of how the old IBM floating
point format represents zero. That broke ratio calculations.

Decision: Nothing is imputed. True missing values stay NULL. Coded
responses stay distinct, and in decoded labels family income uses
'Refused', 'Unknown', and 'Missing' as separate categories. The
income-to-poverty ratio stays null where the source is missing. The
SAS zero artifact is fixed once, in the ingestion script, by setting
near-zero values to 0 before loading. NULLs are unaffected.

Consequences: Raw tables hold true zeros, so no model needs its own
workaround. Tests on columns with legitimate missingness validate only
the non-null values. Fixing the artifact in staging would have meant
every model remembering to apply it.