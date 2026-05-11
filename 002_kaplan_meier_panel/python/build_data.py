"""build_data.py -- Example 002: Paneled KM curves by stratum (Low/High risk)."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=2)
N_SUBJ=50; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; STUDY_END=24.0
STRATA=["Low","High"]; hazard={"Low":{"Placebo":0.05,"Drug A 10mg":0.03,"Drug A 25mg":0.02},"High":{"Placebo":0.12,"Drug A 10mg":0.08,"Drug A 25mg":0.05}}
records=[]; subj=1
for strat in STRATA:
    for trt in TRTS:
        rate=hazard[strat][trt]
        for _ in range(N_SUBJ):
            te=rng.exponential(1/rate); tc=rng.uniform(STUDY_END*0.6,STUDY_END)
            to=min(te,tc,STUDY_END); ev=int(te<=tc and te<=STUDY_END)
            records.append({"subjid":f"S{subj:04d}","stratum":strat,"trt":trt,"time":round(to,2),"event":ev})
            subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False)
print(f"Generated {len(df)} rows across strata: {STRATA}")
