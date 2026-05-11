"""build_data.py -- Example 054: Same data as 043b (bar with CI). Reuses that chart to demo title system."""
import numpy as np, pandas as pd
from scipy.stats import norm as _norm
rng=np.random.default_rng(seed=54); TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; N=80; CATS=["Headache","Nausea","Fatigue","Dizziness","Insomnia"]
base_rates={"Headache":.20,"Nausea":.15,"Fatigue":.25,"Dizziness":.10,"Insomnia":.12}; drug_mult={"Placebo":1.0,"Drug A 10mg":1.3,"Drug A 25mg":1.6}
z=_norm.ppf(.975); records=[]
for cat in CATS:
    for trt in TRTS:
        p=min(.9,base_rates[cat]*drug_mult[trt]); n_event=rng.binomial(N,p); phat=n_event/N
        ci_lo=((phat+z**2/(2*N)-z*(phat*(1-phat)/N+z**2/(4*N**2))**.5)/(1+z**2/N))*100
        ci_hi=((phat+z**2/(2*N)+z*(phat*(1-phat)/N+z**2/(4*N**2))**.5)/(1+z**2/N))*100
        records.append({"trt":trt,"category":cat,"n":n_event,"pct":round(phat*100,1),"ci_lo":round(ci_lo,1),"ci_hi":round(ci_hi,1),"n_total":N})
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
