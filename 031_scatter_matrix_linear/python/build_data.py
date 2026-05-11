"""build_data.py -- Example 031: Scatter matrix (3 Y endpoints vs. baseline X)."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=31)
N_SUBJ=80; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
trt_int={"Placebo":0,"Drug A 10mg":5,"Drug A 25mg":10}
records=[]; subj=1
for trt in TRTS:
    for _ in range(N_SUBJ):
        x=rng.uniform(10,80); c=trt_int[trt]
        records.append({"subjid":f"S{subj:04d}","trt":trt,"x_val":round(x,1),
                         "y1":round(0.7*x+c+rng.normal(0,8),1),
                         "y2":round(0.5*x+c*1.2+rng.normal(0,10),1),
                         "y3":round(0.9*x+c*0.8+rng.normal(0,6),1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
