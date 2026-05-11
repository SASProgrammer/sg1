"""build_data.py -- Example 047: Stacked bar chart of response categories by treatment."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=47); TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
# Response categories: CR, PR, SD, PD (sums to 100%)
base_dist={"Placebo":[5,15,35,45],"Drug A 10mg":[15,30,30,25],"Drug A 25mg":[25,40,25,10]}
CATS=["Complete Response","Partial Response","Stable Disease","Progressive Disease"]
records=[]
for trt in TRTS:
    pcts=base_dist[trt]; noise=[rng.normal(0,2) for _ in CATS]; adj=[p+n for p,n in zip(pcts,noise)]
    total=sum(adj); adj=[round(100*p/total,1) for p in adj]  # normalize to 100
    adj[-1]=round(100-sum(adj[:-1]),1)  # ensure exact 100%
    for cat,pct in zip(CATS,adj): records.append({"trt":trt,"response_cat":cat,"pct":pct})
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.\n{df}")
