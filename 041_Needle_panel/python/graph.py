"""graph.py -- Example 041: Paneled needle plots (one panel per treatment). Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique())
fig,axes=plt.subplots(1,len(trts),figsize=(4*len(trts),6),sharey=True)
for ax,trt in zip(axes,trts):
    sub=df[df["trt"]==trt].reset_index(drop=True)
    ax.vlines(range(len(sub)),0,sub["pct_change"],color="#377EB8",linewidth=1.0)
    ax.axhline(0,color="black",linewidth=0.8,linestyle="--"); ax.set_title(trt,fontweight="bold")
    ax.set_xlabel("Subject"); ax.set_yticks(range(-100,101,20)); ax.set_xticks([]); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
axes[0].set_ylabel("% Change from Baseline",fontsize=11)
fig.suptitle("Paneled Needle Plot: % Change from Baseline",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("041_Needle_panel.pdf",bbox_inches="tight"); fig.savefig("041_Needle_panel.png",bbox_inches="tight",dpi=150)
print("Saved 041_Needle_panel.pdf / .png")
