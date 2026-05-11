"""graph.py -- Example 042: Waterfall chart. Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv").sort_values("best_pct_change").reset_index(drop=True)
colors_map={"Placebo":"black","Drug A 10mg":"#377EB8","Drug A 25mg":"#E41A1C"}
bar_colors=[colors_map[t] for t in df["trt"]]
fig,ax=plt.subplots(figsize=(14,6))
ax.bar(range(len(df)),df["best_pct_change"],color=bar_colors,edgecolor="none",width=1.0)
ax.axhline(0,color="black",linewidth=0.8); ax.axhline(-30,color="gray",linewidth=1,linestyle="--",label="−30% threshold")
ax.set_xlabel("Subject (sorted by % change)",fontsize=12,fontweight="bold"); ax.set_ylabel("Best % Change from Baseline",fontsize=12,fontweight="bold")
ax.set_yticks(range(-100,101,20)); ax.set_xticks([]); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
from matplotlib.patches import Patch
ax.legend(handles=[Patch(facecolor=c,label=t) for t,c in colors_map.items()]+[plt.Line2D([0],[0],color="gray",linestyle="--",label="−30% threshold")],frameon=False,loc="upper left")
ax.set_title("Waterfall Chart: Best % Change from Baseline",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("042_Waterfall.pdf",bbox_inches="tight"); fig.savefig("042_Waterfall.png",bbox_inches="tight",dpi=150)
print("Saved 042_Waterfall.pdf / .png")
