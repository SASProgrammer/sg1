"""
build_data.py  --  Example 006: Median + Q1/Q3 time-series plot
Same data structure as 005_mean; reuses the same synthetic generation.
"""

import numpy as np
import pandas as pd

rng = np.random.default_rng(seed=42)

N_SUBJ = 60
TRTS   = ["Placebo", "Drug A 10mg", "Drug A 25mg"]
WEEKS  = [0, 4, 8, 12, 16, 24]

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
        subj_re = rng.normal(0, 5)
        for wk_idx, wk in enumerate(WEEKS):
            if wk > 8 and rng.random() < 0.10:
                continue
            score = means[wk_idx] + subj_re + rng.normal(0, 8)
            records.append({"subjid": f"S{subj:04d}", "trt": trt, "week": wk, "score": round(score, 2)})
        subj += 1

df = pd.DataFrame(records)
df.to_csv("test_data.csv", index=False)
print(f"Generated {len(df)} rows.")
