"""build_data.py -- Example 048: QTcB over time by treatment."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=48); N_SUBJ=60; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; VISITS=list(range(1,9))
trt_traj={"Placebo":[400,401,402,402,403,403,402,401],"Drug A 10mg":[400,405,410,415,418,420,418,415],"Drug A 25mg":[400,408,418,428,435,440,438,432]}
records=[]; subj=1
for trt in TRTS:
    means=trt_traj[trt]
    for _ in range(N_SUBJ):
        subj_re=rng.normal(0,15)
        for vi,v in enumerate(VISITS):
            if v>4 and rng.random()<.08: continue
            qtcb=means[vi]+subj_re+rng.normal(0,12); records.append({"subjid":f"S{subj:04d}","trt":trt,"visit":v,"qtcb":round(qtcb,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
