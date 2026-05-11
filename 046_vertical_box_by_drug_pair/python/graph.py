"""graph.py -- Example 046: Box plots by drug pair. Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); pairs=sorted(df["drug_pair"].unique()); trts=sorted(df["trt"].unique())
colors=["#377EB8","#E41A1C"]; fig,axes=plt.subplots(1,len(pairs),figsize=(4*len(pairs),6),sharey=True)
for ax,pair in zip(axes,pairs):
    data=[df[(df["drug_pair"]==pair)&(df["trt"]==t)]["value"].values for t in trts]
    bp=ax.boxplot(data,labels=trts,patch_artist=True,widths=.5)
    for patch,color in zip(bp["boxes"],colors): patch.set_facecolor(color); patch.set_alpha(.8)
    ax.set_title(pair,fontweight="bold"); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
axes[0].set_ylabel("Value",fontsize=11)
fig.suptitle("Box Plot by Drug Pair and Treatment",fontsize=13,fontweight="bold"); fig.tight_layout()
fig.savefig("046_vertical_box_by_drug_pair.pdf",bbox_inches="tight"); fig.savefig("046_vertical_box_by_drug_pair.png",bbox_inches="tight",dpi=150)
print("Saved 046_vertical_box_by_drug_pair.pdf / .png")
