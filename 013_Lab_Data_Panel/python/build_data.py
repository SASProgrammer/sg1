"""build_data.py -- Example 013: Paneled lab data. 3 lab tests × 3 treatments × 8 visits."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=13)
N_SUBJ=50; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; VISITS=list(range(1,9))
LABS=["ALT","Creatinine","Hemoglobin"]
trt_traj={
    "ALT":{"Placebo":[28,28,29,29,30,30,30,29],"Drug A 10mg":[28,29,31,33,34,34,33,32],"Drug A 25mg":[28,31,36,41,43,44,42,40],"sd":7},
    "Creatinine":{"Placebo":[0.9,0.91,0.92,0.92,0.93,0.93,0.93,0.92],"Drug A 10mg":[0.9,0.92,0.95,0.97,0.98,0.98,0.97,0.96],"Drug A 25mg":[0.9,0.95,1.0,1.05,1.07,1.08,1.07,1.05],"sd":0.12},
    "Hemoglobin":{"Placebo":[13.5,13.4,13.3,13.3,13.2,13.2,13.2,13.3],"Drug A 10mg":[13.5,13.6,13.8,14.0,14.0,14.1,14.1,14.0],"Drug A 25mg":[13.5,13.8,14.2,14.5,14.6,14.7,14.7,14.6],"sd":1.0},
}
records=[]; subj=1
for lab in LABS:
    cfg=trt_traj[lab]
    for trt in TRTS:
        means=cfg[trt]; sd=cfg["sd"]
        for _ in range(N_SUBJ):
            subj_re=rng.normal(0,sd*0.4)
            for vi,v in enumerate(VISITS):
                if v>4 and rng.random()<0.08: continue
                records.append({"subjid":f"S{subj:04d}","labtest":lab,"trt":trt,"visit":v,"lbresult":round(means[vi]+subj_re+rng.normal(0,sd),3)})
            subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False)
print(f"Generated {len(df)} rows.")
