"""
build_data.py  --  Example 010: Basic laboratory data time-series plot
Generates ALT lab values across study visits for 3 treatment arms.
"""

import numpy as np
import pandas as pd

rng = np.random.default_rng(seed=10)

N_SUBJ = 60
TRTS   = ["Placebo", "Drug A 10mg", "Drug A 25mg"]
VISITS = [1, 2, 3, 4, 5, 6, 7, 8]   # visit numbers

trt_traj = {
    "Placebo":     [28, 28, 29, 29, 30, 30, 30, 29],
    "Drug A 10mg": [28, 29, 31, 33, 34, 34, 33, 32],
    "Drug A 25mg": [28, 31, 36, 41, 43, 44, 42, 40],
}

records = []; subj = 1
for trt in TRTS:
    means = trt_traj[trt]
    for _ in range(N_SUBJ):
        subj_re = rng.normal(0, 4)
        for vis_idx, vis in enumerate(VISITS):
            if vis > 4 and rng.random() < 0.08:
                continue
            lbresult = means[vis_idx] + subj_re + rng.normal(0, 7)
            records.append({"subjid": f"S{subj:04d}", "trt": trt,
                             "visit": vis, "lbresult": round(lbresult, 2)})
        subj += 1

df = pd.DataFrame(records)
df.to_csv("test_data.csv", index=False)
print(f"Generated {len(df)} rows, {df['subjid'].nunique()} subjects.")
