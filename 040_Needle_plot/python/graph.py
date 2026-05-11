"""graph.py -- Example 040: Needle plot. Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique()); colors=["black","#377EB8","#E41A1C"]
fig,ax=plt.subplots(figsize=(12,6))
x=0
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt].reset_index(drop=True)
    for j,row in sub.iterrows():
        ax.vlines(x,0,row["pct_change"],color=colors[i],linewidth=1.2)
        x+=1
    ax.vlines(x,0,0,color="none",label=trt); x+=2
ax.axhline(0,color="black",linewidth=0.8,linestyle="--")
ax.set_xlabel("Subject (grouped by treatment)",fontsize=12,fontweight="bold"); ax.set_ylabel("% Change from Baseline",fontsize=12,fontweight="bold")
ax.set_yticks(range(-100,101,20)); ax.set_xticks([]); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(frameon=False); ax.set_title("Needle Plot: % Change from Baseline",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("040_Needle_plot.pdf",bbox_inches="tight"); fig.savefig("040_Needle_plot.png",bbox_inches="tight",dpi=150)
print("Saved 040_Needle_plot.pdf / .png")
