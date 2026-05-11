"""graph.py -- Example 052: QT vs RR interval with Bazett correction overlay. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt; from scipy import stats
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique()); colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]
fig,ax=plt.subplots(figsize=(9,7))
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt]; ax.scatter(sub["rr_interval"],sub["qt_interval"],color=colors[i],marker=markers[i],alpha=.7,s=40,label=trt)
# Bazett reference curve: QT = 450 * sqrt(RR/1000)
rr_ref=np.linspace(600,1200,200); qt_bazett=450*np.sqrt(rr_ref/1000)
ax.plot(rr_ref,qt_bazett,"k-.",linewidth=1.5,label="Bazett QTcB=450 ms")
sl,ic,r,_,_=stats.linregress(df["rr_interval"],df["qt_interval"]); ax.plot(rr_ref,sl*rr_ref+ic,"k--",linewidth=1.2,label=f"Linear fit (r={r:.2f})")
ax.set_xlabel("RR Interval (ms)",fontsize=12,fontweight="bold"); ax.set_ylabel("QT Interval (ms)",fontsize=12,fontweight="bold")
ax.set_xlim(600,1200); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False); ax.legend(frameon=False,fontsize=9)
ax.set_title("QT vs. RR Interval Relationship",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("052_qt_relation_rr.pdf",bbox_inches="tight"); fig.savefig("052_qt_relation_rr.png",bbox_inches="tight",dpi=150)
print("Saved 052_qt_relation_rr.pdf / .png")
