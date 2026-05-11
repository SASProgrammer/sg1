"""build_data.py -- Example 045: Vertical bar panels by visit."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=45); TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; VISITS=[4,8,12,24]
base_resp={"Placebo":.10,"Drug A 10mg":.30,"Drug A 25mg":.50}; time_increase={"Placebo":.02,"Drug A 10mg":.05,"Drug A 25mg":.07}
records=[]
for vis in VISITS:
    for trt in TRTS:
        p=min(.9,base_resp[trt]+time_increase[trt]*(vis//4)); n=rng.binomial(80,p); pct=round(100*n/80,1)
        records.append({"trt":trt,"visit":vis,"n":n,"pct":pct})
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
