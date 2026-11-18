# 0008: Omega-6 to omega-3 ratio definition

Status: Accepted (2026-11)

Context: NHANES has no ratio variable. Omega-3 and omega-6 intake can
be defined several ways, and the ratio is unstable when omega-3 is
near zero.

Decision: The ratio is omega-6 divided by omega-3. Omega-6 is linoleic
acid (PFA 18:2) only. Omega-3 is EPA (PFA 20:5) plus DHA (PFA 22:6).
ALA, arachidonic acid, and DPA are excluded. The ratio is null when
omega-3 intake is zero. No cap or transformation is applied in the
fact table.

Consequences: The simple definition is easy to explain, and the evidence
for cardiovascular benefit is strongest for the long-chain marine
forms. The ratio is heavily right-skewed. Trace omega-3 intake
produces very large values (the sample maximum is about 64,000 from
0.0005 g of EPA), and these are arithmetic results, not errors. The
only test is non-negative, because any upper bound would be arbitrary.
Downstream analysis should use a log transform or a bounded
alternative.