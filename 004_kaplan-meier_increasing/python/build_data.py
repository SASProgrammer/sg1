"""build_data.py -- Example 004: Cumulative incidence (1-KM). Time to response."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=4)
N_SUBJ=60; STUDY_END=24.0; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
# Lower rate = slower response; treatment should have higher response rate
resp_rates={"Placebo":0.04,"Drug A 10mg":0.08,"Drug A 25mg":0.12}
records=[]; subj=1
for trt in TRTS:
    rate=resp_rates[trt]
    for _ in range(N_SUBJ):
        te=rng.exponential(1/rate)  # time to response
        tc=rng.uniform(STUDY_END*0.5,STUDY_END)  # censoring
        to=min(te,tc,STUDY_END); resp=int(te<=tc and te<=STUDY_END)
        records.append({"subjid":f"S{subj:04d}","trt":trt,"time":round(to,2),"response":resp}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False)
print(f"Generated {len(df)} rows."); print(df.groupby("trt")["response"].agg(["sum","count"]))
