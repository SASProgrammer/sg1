"""graph.py -- Example 043: Grouped bar chart. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); cats=df["category"].unique(); trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; x=np.arange(len(cats)); width=0.25
fig,ax=plt.subplots(figsize=(10,6))
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt].set_index("category").reindex(cats)
    ax.bar(x+i*width,sub["pct"],width,label=trt,color=colors[i],edgecolor="white")
ax.set_xlabel("Adverse Event Category",fontsize=12,fontweight="bold"); ax.set_ylabel("Incidence (%)",fontsize=12,fontweight="bold")
ax.set_xticks(x+width); ax.set_xticklabels(cats,rotation=30,ha="right"); ax.set_ylim(0,70); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(frameon=False); ax.set_title("Incidence by Category and Treatment",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("043_barchart_geo.pdf",bbox_inches="tight"); fig.savefig("043_barchart_geo.png",bbox_inches="tight",dpi=150)
print("Saved 043_barchart_geo.pdf / .png")
