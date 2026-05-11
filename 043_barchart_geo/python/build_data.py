"""build_data.py -- Example 043: Grouped bar chart (incidence by AE category and treatment)."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=43)
TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; N={"Placebo":80,"Drug A 10mg":80,"Drug A 25mg":80}
CATS=["Headache","Nausea","Fatigue","Dizziness","Insomnia"]
base_rates={"Headache":.20,"Nausea":.15,"Fatigue":.25,"Dizziness":.10,"Insomnia":.12}
drug_mult={"Placebo":1.0,"Drug A 10mg":1.3,"Drug A 25mg":1.6}
records=[]
for cat in CATS:
    for trt in TRTS:
        n_total=N[trt]; p=min(0.9,base_rates[cat]*drug_mult[trt]); n_event=rng.binomial(n_total,p); pct=round(100*n_event/n_total,1)
        records.append({"trt":trt,"category":cat,"n":n_event,"pct":pct,"n_total":n_total})
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
