"""
build_data.py  --  Example 008: Mean panels in matrix layout
Same longitudinal lab data as 007; 3 lab tests × 3 treatments.
"""

import numpy as np
import pandas as pd

rng = np.random.default_rng(seed=8)

N_SUBJ = 50
TRTS   = ["Placebo", "Drug A 10mg", "Drug A 25mg"]
WEEKS  = [0, 4, 8, 12, 16, 24]
LABS   = ["Hemoglobin", "Creatinine", "ALT"]

lab_config = {
    "Hemoglobin": {
        "Placebo":     [13.5, 13.4, 13.3, 13.3, 13.2, 13.2],
        "Drug A 10mg": [13.5, 13.6, 13.8, 14.0, 14.0, 14.1],
        "Drug A 25mg": [13.5, 13.8, 14.2, 14.5, 14.6, 14.7],
        "sd": 1.2,
    },
    "Creatinine": {
        "Placebo":     [0.9, 0.91, 0.92, 0.92, 0.93, 0.93],
        "Drug A 10mg": [0.9, 0.92, 0.95, 0.97, 0.98, 0.98],
        "Drug A 25mg": [0.9, 0.95, 1.00, 1.05, 1.07, 1.08],
        "sd": 0.15,
    },
    "ALT": {
        "Placebo":     [28, 29, 29, 30, 30, 30],
        "Drug A 10mg": [28, 30, 32, 34, 34, 33],
        "Drug A 25mg": [28, 33, 38, 42, 43, 41],
        "sd": 8,
    },
}

records = []
subj = 1
for lab in LABS:
    cfg = lab_config[lab]
    for trt in TRTS:
        means = cfg[trt]
        sd    = cfg["sd"]
        for _ in range(N_SUBJ):
            subj_re = rng.normal(0, sd * 0.4)
            for wk_idx, wk in enumerate(WEEKS):
                if wk > 8 and rng.random() < 0.08:
                    continue
                result = means[wk_idx] + subj_re + rng.normal(0, sd)
                records.append({"subjid": f"S{subj:04d}", "labtest": lab, "trt": trt,
                                 "week": wk, "result": round(result, 3)})
            subj += 1

df = pd.DataFrame(records)
df.to_csv("test_data.csv", index=False)
print(f"Generated {len(df)} rows.")
