"""build_data.py -- Example 012: Lab data with N= in plot area. Same data as 010."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=12)
N_SUBJ=60; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; VISITS=list(range(1,9))
trt_traj={"Placebo":[28,28,29,29,30,30,30,29],"Drug A 10mg":[28,29,31,33,34,34,33,32],"Drug A 25mg":[28,31,36,41,43,44,42,40]}
records=[]; subj=1
for trt in TRTS:
    means=trt_traj[trt]
    for _ in range(N_SUBJ):
        subj_re=rng.normal(0,4)
        for vi,v in enumerate(VISITS):
            if v>4 and rng.random()<0.08: continue
            records.append({"subjid":f"S{subj:04d}","trt":trt,"visit":v,"lbresult":round(means[vi]+subj_re+rng.normal(0,7),2)})
        subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False)
print(f"Generated {len(df)} rows.")
