"""build_data.py -- Example 035: Single scatter with linear regression."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=35)
N_SUBJ=80; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
# Positive correlation; drug arm shifts y upward
trt_int={"Placebo":0,"Drug A 10mg":5,"Drug A 25mg":10}
records=[]; subj=1
for trt in TRTS:
    for _ in range(N_SUBJ):
        x=rng.uniform(10,80); y=0.7*x+trt_int[trt]+rng.normal(0,8)
        records.append({"subjid":f"S{subj:04d}","trt":trt,"x_val":round(x,1),"y_val":round(y,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
