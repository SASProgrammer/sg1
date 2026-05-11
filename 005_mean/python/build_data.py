"""
build_data.py  --  Example 005: Mean +/- 95% CI time-series plot
Generates synthetic longitudinal test data and saves to test_data.csv.
"""

import numpy as np
import pandas as pd

rng = np.random.default_rng(seed=42)

N_SUBJ = 60          # subjects per treatment arm
TRTS   = ["Placebo", "Drug A 10mg", "Drug A 25mg"]
WEEKS  = [0, 4, 8, 12, 16, 24]

# Treatment-specific mean trajectories (baseline → peak → plateau)
trt_effects = {
    "Placebo":      [50, 51, 52, 52, 53, 53],
    "Drug A 10mg":  [50, 46, 42, 40, 39, 38],
    "Drug A 25mg":  [50, 43, 37, 33, 31, 30],
}

records = []
subj = 1
for trt in TRTS:
    means = trt_effects[trt]
    for _ in range(N_SUBJ):
        # Subject-level random effect
        subj_re = rng.normal(0, 5)
        for wk_idx, wk in enumerate(WEEKS):
            # Simulate missing data (~10% dropout after week 8)
            if wk > 8 and rng.random() < 0.10:
                continue
            score = means[wk_idx] + subj_re + rng.normal(0, 8)
            records.append({
                "subjid": f"S{subj:04d}",
                "trt":    trt,
                "week":   wk,
                "score":  round(score, 2),
            })
        subj += 1

df = pd.DataFrame(records)
df.to_csv("test_data.csv", index=False)
print(f"Generated {len(df)} rows across {df['subjid'].nunique()} subjects.")
print(df.groupby(["trt", "week"])["score"].agg(["mean", "count"]).round(2))
