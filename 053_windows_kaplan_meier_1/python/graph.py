"""
graph.py -- Example 053: KM curve styled for PowerPoint (dark background, high contrast).
In Python we produce a dark-background matplotlib figure mimicking the EMF pcgraph style.
Run build_data.py first.  Requires: pip install lifelines
"""
import pandas as pd, matplotlib.pyplot as plt, matplotlib as mpl
try: from lifelines import KaplanMeierFitter
except ImportError: raise ImportError("pip install lifelines")

df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique())
colors=["white","yellow","cyan"]; ltys=["-","--","-."]
with mpl.rc_context({"axes.facecolor":"#0000DC","figure.facecolor":"#0000DC","savefig.facecolor":"#0000DC",
                     "text.color":"white","axes.labelcolor":"white","xtick.color":"white","ytick.color":"white",
                     "axes.edgecolor":"white","legend.labelcolor":"white"}):
    fig,ax=plt.subplots(figsize=(10,7))
    for i,trt in enumerate(trts):
        sub=df[df["trt"]==trt]; kmf=KaplanMeierFitter(); kmf.fit(sub["time"],event_observed=sub["event"],label=trt)
        kmf.plot_survival_function(ax=ax,ci_show=False,color=colors[i],linestyle=ltys[i],linewidth=2.5)
    ax.set_xlabel("Time (Months)",fontsize=14,fontweight="bold"); ax.set_ylabel("Survival Probability (%)",fontsize=14,fontweight="bold")
    ax.set_ylim(0,1.05); ax.set_xlim(0,24); ax.set_xticks(range(0,25,4))
    ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y,_:f"{y*100:.0f}"))
    ax.legend(loc="upper right",frameon=False,fontsize=11)
    ax.set_title("Kaplan-Meier Survival Estimates by Treatment",fontsize=15,fontweight="bold",color="white")
    fig.tight_layout()
    fig.savefig("053_windows_kaplan_meier_1_ppt.png",bbox_inches="tight",dpi=150)
# Also save standard B&W version (PDF)
fig2,ax2=plt.subplots(figsize=(9,6))
colors2=["black","#377EB8","#E41A1C"]
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt]; kmf=KaplanMeierFitter(); kmf.fit(sub["time"],event_observed=sub["event"],label=trt)
    kmf.plot_survival_function(ax=ax2,ci_show=True,color=colors2[i],linestyle=ltys[i],linewidth=2)
ax2.set_xlabel("Time (Months)",fontsize=12,fontweight="bold"); ax2.set_ylabel("Survival Probability",fontsize=12,fontweight="bold")
ax2.set_ylim(0,1.05); ax2.set_xlim(0,24); ax2.set_xticks(range(0,25,4))
ax2.yaxis.set_major_formatter(plt.FuncFormatter(lambda y,_:f"{y:.0%}"))
ax2.spines["top"].set_visible(False); ax2.spines["right"].set_visible(False)
ax2.legend(loc="upper right",frameon=False); ax2.set_title("KM Survival Estimates",fontsize=13,fontweight="bold")
fig2.tight_layout(); fig2.savefig("053_windows_kaplan_meier_1.pdf",bbox_inches="tight"); fig2.savefig("053_windows_kaplan_meier_1.png",bbox_inches="tight",dpi=150)
print("Saved 053_windows_kaplan_meier_1.pdf / .png / _ppt.png")
