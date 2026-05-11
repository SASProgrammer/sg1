"""
build_data.py  --  Example 001: Basic Kaplan-Meier survival curve
Generates time-to-event data for 3 treatment arms using exponential survival.
"""

import numpy as np
import pandas as pd

rng = np.random.default_rng(seed=1)

N_SUBJ      = 50          # subjects per arm
STUDY_END   = 24.0        # months
TRTS        = ["Placebo", "Drug A 10mg", "Drug A 25mg"]

# Exponential rate parameters (higher rate = worse survival)
hazard_rates = {"Placebo": 0.08, "Drug A 10mg": 0.05, "Drug A 25mg": 0.03}

records = []
subj = 1
for trt in TRTS:
    rate = hazard_rates[trt]
    for _ in range(N_SUBJ):
        # Simulated time to event (exponential distribution)
        time_event = rng.exponential(1.0 / rate)
        # Administrative censoring at study end
        time_censor = rng.uniform(STUDY_END * 0.6, STUDY_END)
        time_obs = min(time_event, time_censor, STUDY_END)
        event = int(time_event <= time_censor and time_event <= STUDY_END)
        records.append({
            "subjid": f"S{subj:04d}",
            "trt":    trt,
            "time":   round(time_obs, 2),
            "event":  event,
        })
        subj += 1

df = pd.DataFrame(records)
df.to_csv("test_data.csv", index=False)
print(f"Generated {len(df)} rows.")
print(df.groupby("trt")["event"].agg(["sum", "count"]).rename(columns={"sum": "events", "count": "n"}))
