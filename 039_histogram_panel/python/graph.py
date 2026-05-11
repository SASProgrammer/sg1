"""graph.py -- Example 039_panel: Paneled histograms (one per treatment). Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique()); bins=range(0,101,10)
fig,axes=plt.subplots(1,len(trts),figsize=(4*len(trts),5),sharex=True,sharey=True)
for ax,trt in zip(axes,trts):
    ax.hist(df[df["trt"]==trt]["value"],bins=bins,color="#377EB8",edgecolor="white")
    ax.set_title(trt,fontweight="bold"); ax.set_xlabel("Value"); ax.set_ylabel("Frequency"); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
fig.suptitle("Histogram of Value by Treatment (Panels)",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("039_histogram_panel.pdf",bbox_inches="tight"); fig.savefig("039_histogram_panel.png",bbox_inches="tight",dpi=150)
print("Saved 039_histogram_panel.pdf / .png")
