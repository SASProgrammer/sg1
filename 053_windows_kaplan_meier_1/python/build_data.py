"""build_data.py -- Example 053: Windows-style KM. Same data as 001."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=53)
N_SUBJ=50; STUDY_END=24.0; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
hazard_rates={"Placebo":0.08,"Drug A 10mg":0.05,"Drug A 25mg":0.03}
records=[]; subj=1
for trt in TRTS:
    rate=hazard_rates[trt]
    for _ in range(N_SUBJ):
        te=rng.exponential(1/rate); tc=rng.uniform(STUDY_END*0.6,STUDY_END)
        to=min(te,tc,STUDY_END); ev=int(te<=tc and te<=STUDY_END)
        records.append({"subjid":f"S{subj:04d}","trt":trt,"time":round(to,2),"event":ev}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
