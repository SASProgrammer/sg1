"""graph.py -- Example 049: QTcB vs drug concentration with regression. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt; from scipy import stats
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique()); colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]
fig,ax=plt.subplots(figsize=(9,7))
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt]; ax.scatter(sub["conc"],sub["qtcb"],color=colors[i],marker=markers[i],alpha=.7,s=45,label=trt)
sl,ic,r,_,_=stats.linregress(df["conc"],df["qtcb"]); x_l=np.linspace(df["conc"].min(),df["conc"].max(),200)
ax.plot(x_l,sl*x_l+ic,"k--",linewidth=1.5,label=f"Regression (r={r:.2f})")
ax.axhline(450,color="gray",linewidth=1,linestyle=":",label="450 ms threshold")
ax.set_xlabel("Drug Concentration (ng/mL)",fontsize=12,fontweight="bold"); ax.set_ylabel("QTcB (ms)",fontsize=12,fontweight="bold")
ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False); ax.legend(frameon=False,fontsize=9)
ax.set_title("QTcB vs. Drug Concentration",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("049_qtcb_vs_serum.pdf",bbox_inches="tight"); fig.savefig("049_qtcb_vs_serum.png",bbox_inches="tight",dpi=150)
print("Saved 049_qtcb_vs_serum.pdf / .png")
