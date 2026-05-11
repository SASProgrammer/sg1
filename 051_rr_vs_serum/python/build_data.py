"""build_data.py -- Example 051: RR interval vs drug concentration."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=51); N_SUBJ=80; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
conc_range={"Placebo":(0,.5),"Drug A 10mg":(.5,3.0),"Drug A 25mg":(2.5,8.0)}; records=[]; subj=1
for trt in TRTS:
    cmin,cmax=conc_range[trt]
    for _ in range(N_SUBJ):
        conc=rng.uniform(cmin,cmax); rr=-8*conc+900+rng.normal(0,40)  # drug increases HR = decreases RR
        records.append({"subjid":f"S{subj:04d}","trt":trt,"conc":round(conc,3),"rr_interval":round(rr,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
