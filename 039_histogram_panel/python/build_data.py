"""build_data.py -- Example 039_panel: Paneled histograms. Same data as 039."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=391)
N_SUBJ=100; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; trt_params={"Placebo":(45,15),"Drug A 10mg":(55,14),"Drug A 25mg":(62,12)}
records=[]; subj=1
for trt in TRTS:
    mu,sd=trt_params[trt]
    for _ in range(N_SUBJ):
        v=max(0,min(100,rng.normal(mu,sd))); records.append({"subjid":f"S{subj:04d}","trt":trt,"value":round(v,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
