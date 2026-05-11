"""graph.py -- Example 039: Histogram. Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique())
colors=["gray","#377EB8","#E41A1C"]; bins=range(0,101,10)
fig,ax=plt.subplots(figsize=(9,6))
for i,trt in enumerate(trts):
    ax.hist(df[df["trt"]==trt]["value"],bins=bins,alpha=0.6,color=colors[i],edgecolor="white",label=trt)
ax.set_xlabel("Value",fontsize=12,fontweight="bold"); ax.set_ylabel("Frequency",fontsize=12,fontweight="bold")
ax.set_xticks(range(0,101,10)); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(frameon=False); ax.set_title("Histogram of Value by Treatment",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("039_histogram.pdf",bbox_inches="tight"); fig.savefig("039_histogram.png",bbox_inches="tight",dpi=150)
print("Saved 039_histogram.pdf / .png")
