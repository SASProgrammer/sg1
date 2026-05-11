"""build_data.py -- Example 042: Waterfall chart of best % change from baseline."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=42); N_SUBJ=50; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
trt_mean={"Placebo":10,"Drug A 10mg":-25,"Drug A 25mg":-45}; records=[]; subj=1
for trt in TRTS:
    for _ in range(N_SUBJ):
        pct=max(-100,min(100,trt_mean[trt]+rng.normal(0,30))); records.append({"subjid":f"S{subj:04d}","trt":trt,"best_pct_change":round(pct,1)}); subj+=1
df=pd.DataFrame(records).sort_values("best_pct_change").reset_index(drop=True)
df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
