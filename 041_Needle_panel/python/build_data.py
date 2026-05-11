"""build_data.py -- Example 041: Paneled needle plots. Same data as 040."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=41); N_SUBJ=50; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
trt_mean={"Placebo":5,"Drug A 10mg":-20,"Drug A 25mg":-40}; records=[]; subj=1
for trt in TRTS:
    for _ in range(N_SUBJ):
        pct=max(-100,min(100,trt_mean[trt]+rng.normal(0,25))); records.append({"subjid":f"S{subj:04d}","trt":trt,"pct_change":round(pct,1)}); subj+=1
df=pd.DataFrame(records).sort_values(["trt","pct_change"]).reset_index(drop=True)
df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
