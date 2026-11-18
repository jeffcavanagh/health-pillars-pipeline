# 0001: Survey weights are not applied

Status: Accepted (2026-11)

Context: NHANES oversamples some groups on purpose, so unweighted
results describe the sample, not the US population. Correct inference
needs survey weights and design-based variance methods.

Decision: The project does not implement them.

Consequences: Results can't be generalized to the population. The
README and docs state this. Weights could be added later because the
weight columns are available in the raw files.