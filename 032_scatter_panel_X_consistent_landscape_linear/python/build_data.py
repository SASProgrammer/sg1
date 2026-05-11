"""build_data.py -- Examples 032-034: Scatter panels. Generates panel×trt×subj data."""
import numpy as np, pandas as pd
rng=np.random.default_rng(seed=32)
N_SUBJ=60; TRTS=["Placebo","Drug A 10mg","Drug A 25mg"]; PANELS=["Visit 1","Visit 2","Visit 3"]
trt_int={"Placebo":0,"Drug A 10mg":6,"Drug A 25mg":12}; panel_shift={"Visit 1":0,"Visit 2":5,"Visit 3":10}
records=[]; subj=1
for panel in PANELS:
    for trt in TRTS:
        for _ in range(N_SUBJ):
            x=rng.uniform(10,80); y=0.65*x+trt_int[trt]+panel_shift[panel]+rng.normal(0,9)
            records.append({"subjid":f"S{subj:04d}","panel":panel,"trt":trt,"x_val":round(x,1),"y_val":round(y,1)}); subj+=1
df=pd.DataFrame(records); df.to_csv("test_data.csv",index=False); print(f"Generated {len(df)} rows.")
