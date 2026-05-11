"""build_data.py -- Example 049: QTcB vs drug concentration (PK/PD)."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=49); N_SUBJ=80; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
conc_range={"Placebo":(0,0.5),"Drug A 10mg":(0.5,3.0),"Drug A 25mg":(2.5,8.0)}
records=[]; subj=1
for trt in TRTS:
    cmin,cmax=conc_range[trt]
    for _ in range(N_SUBJ):
        conc=rng.uniform(cmin,cmax); qtcb=400+4*conc+rng.normal(0,15)  # linear PKPD relationship
        records.append({"subjid":f"S{subj:04d}","trt":trt,"conc":round(conc,3),"qtcb":round(qtcb,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
