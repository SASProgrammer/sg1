"""graph.py -- Example 047: Stacked bar chart. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); trts=["Placebo","Drug A 10mg","Drug A 25mg"]
cats=["Complete Response","Partial Response","Stable Disease","Progressive Disease"]
colors=["#2ecc71","#27ae60","#f39c12","#e74c3c"]
fig,ax=plt.subplots(figsize=(9,6)); bottom={t:0 for t in trts}
for cat,color in zip(cats,colors):
    vals=[df[(df["trt"]==t)&(df["response_cat"]==cat)]["pct"].values[0] for t in trts]
    ax.bar(trts,vals,bottom=[bottom[t] for t in trts],label=cat,color=color,edgecolor="white",width=.6)
    for t,v in zip(trts,vals):
        if v>4: ax.text(trts.index(t),bottom[t]+v/2,f"{v:.0f}%",ha="center",va="center",fontsize=9,color="white",fontweight="bold")
        bottom[t]+=v
ax.set_ylim(0,105); ax.set_ylabel("Percentage (%)",fontsize=12,fontweight="bold"); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(loc="upper right",frameon=False,fontsize=9,title="Response"); ax.set_title("Response Categories by Treatment",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("047_stacked_bar_chart.pdf",bbox_inches="tight"); fig.savefig("047_stacked_bar_chart.png",bbox_inches="tight",dpi=150)
print("Saved 047_stacked_bar_chart.pdf / .png")
