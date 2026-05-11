"""build_data.py -- Example 052: QT vs RR interval relationship."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=52); N_SUBJ=100; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]
# Drug slows heart rate (increases RR) and may prolong QT
drug_rr_effect={"Placebo":0,"Drug A 10mg":-30,"Drug A 25mg":-60}  # reduction in RR
drug_qt_effect={"Placebo":0,"Drug A 10mg":8,"Drug A 25mg":18}
records=[]; subj=1
for trt in TRTS:
    for _ in range(N_SUBJ):
        rr=rng.normal(900+drug_rr_effect[trt],80)  # baseline RR ~900ms
        qt=0.35*rr+drug_qt_effect[trt]+rng.normal(0,15)  # QT ~ 0.35*RR (Bazett linearized)
        records.append({"subjid":f"S{subj:04d}","trt":trt,"rr_interval":round(rr,1),"qt_interval":round(qt,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
