"""graph.py -- Example 030: Subject disposition stacked bar. Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); trts=["Placebo","Drug A 10mg","Drug A 25mg"]
cats=["Completed","Withdrew Consent","Adverse Event","Lost to Follow-up"]
colors=["#2ecc71","#f1c40f","#e67e22","#e74c3c"]
fig,ax=plt.subplots(figsize=(8,7)); bottom={t:0 for t in trts}
for cat,color in zip(cats,colors):
    vals=[df[(df["trt"]==t)&(df["disposition_cat"]==cat)]["pct"].values[0] for t in trts]
    ax.bar(trts,vals,bottom=[bottom[t] for t in trts],label=cat,color=color,edgecolor="white",width=.6)
    for t,v in zip(trts,vals):
        if v>4: ax.text(trts.index(t),bottom[t]+v/2,f"{v:.0f}%",ha="center",va="center",fontsize=10,color="white",fontweight="bold")
        bottom[t]+=v
ax.set_ylim(0,105); ax.set_ylabel("Subjects (%)",fontsize=12,fontweight="bold"); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(loc="upper right",frameon=False,fontsize=10); ax.set_title("Subject Disposition by Treatment",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("030_subject_disposition_with_cumulative_percent.pdf",bbox_inches="tight"); fig.savefig("030_subject_disposition_with_cumulative_percent.png",bbox_inches="tight",dpi=150)
print("Saved 030_subject_disposition_with_cumulative_percent.pdf / .png")
