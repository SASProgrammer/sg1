"""
graph.py -- Example 003: KM curves with Sidak simultaneous CI adjustment.
Sidak alpha* = 1 - (1 - 0.05)^(1/k) where k = number of treatment arms.
Run build_data.py first.  Requires: pip install lifelines
"""
import pandas as pd, numpy as np, matplotlib.pyplot as plt
try: from lifelines import KaplanMeierFitter
except ImportError: raise ImportError("pip install lifelines")

df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique())
k=len(trts); alpha_sidak=1-(1-0.05)**(1/k)
colors=["black","#377EB8","#E41A1C"]; ltys=["-","--","-."]
fig,ax=plt.subplots(figsize=(9,6))
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt]
    kmf=KaplanMeierFitter()
    kmf.fit(sub["time"],event_observed=sub["event"],label=trt,alpha=alpha_sidak)
    kmf.plot_survival_function(ax=ax,ci_show=True,color=colors[i],linestyle=ltys[i],linewidth=2)
ax.set_xlabel("Time (Months)",fontsize=12,fontweight="bold"); ax.set_ylabel("Survival Probability",fontsize=12,fontweight="bold")
ax.set_ylim(0,1.05); ax.set_xlim(0,24); ax.set_xticks(range(0,25,4))
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y,_:f"{y:.0%}"))
ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(loc="upper right",frameon=False,fontsize=10)
ax.set_title(f"KM Survival with Sidak CI (α*={alpha_sidak:.4f})",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("003_kaplan-meier_sidak.pdf",bbox_inches="tight"); fig.savefig("003_kaplan-meier_sidak.png",bbox_inches="tight",dpi=150)
print("Saved 003_kaplan-meier_sidak.pdf / .png")
