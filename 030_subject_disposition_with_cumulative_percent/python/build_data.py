"""build_data.py -- Example 030: Subject disposition stacked bar with cumulative %."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=30); TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; N=100
CATS=["Completed","Withdrew Consent","Adverse Event","Lost to Follow-up"]
base_pcts={"Placebo":[65,12,15,8],"Drug A 10mg":[72,10,12,6],"Drug A 25mg":[70,8,17,5]}
records=[]
for trt in TRTS:
    pcts=base_pcts[trt]; noise=[rng.normal(0,1) for _ in CATS]
    adj=[max(0,p+n) for p,n in zip(pcts,noise)]; total=sum(adj); adj=[round(100*p/total,1) for p in adj]; adj[-1]=round(100-sum(adj[:-1]),1)
    n_counts=adj.copy(); n_counts[-1]=round(N-sum([round(N*p/100) for p in adj[:-1]]))
    for cat,pct,n_cat in zip(CATS,adj,[round(N*p/100) for p in adj]):
        records.append({"trt":trt,"disposition_cat":cat,"n":n_cat,"pct":pct})
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.\n{df}")
