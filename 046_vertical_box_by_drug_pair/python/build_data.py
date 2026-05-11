"""build_data.py -- Example 046: Box plots by drug pair."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=46); N_SUBJ=60; PAIRS=["Pair 1","Pair 2","Pair 3"]; TRTS=["Drug A","Drug B"]
pair_means={"Pair 1":{"Drug A":50,"Drug B":45},"Pair 2":{"Drug A":60,"Drug B":55},"Pair 3":{"Drug A":55,"Drug B":48}}
records=[]; subj=1
for pair in PAIRS:
    for trt in TRTS:
        for _ in range(N_SUBJ):
            v=rng.normal(pair_means[pair][trt],12); records.append({"subjid":f"S{subj:04d}","drug_pair":pair,"trt":trt,"value":round(v,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
