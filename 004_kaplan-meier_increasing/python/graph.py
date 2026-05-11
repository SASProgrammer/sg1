"""graph.py -- Example 004: Cumulative incidence (1 - KM). Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
try: from lifelines import KaplanMeierFitter
except ImportError: raise ImportError("pip install lifelines")

df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; ltys=["-","--","-."]
fig,ax=plt.subplots(figsize=(9,6))
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt]
    kmf=KaplanMeierFitter(); kmf.fit(sub["time"],event_observed=sub["response"],label=trt)
    # Plot 1 - survival = cumulative incidence
    t=kmf.survival_function_.index.values; ci=(1-kmf.survival_function_["KM_estimate"]).values
    ax.step(t,ci,where="post",color=colors[i],linestyle=ltys[i],linewidth=2,label=trt)
ax.set_xlabel("Time (Months)",fontsize=12,fontweight="bold"); ax.set_ylabel("Cumulative Response (%)",fontsize=12,fontweight="bold")
ax.set_ylim(0,1.05); ax.set_xlim(0,24); ax.set_xticks(range(0,25,4))
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y,_:f"{y:.0%}"))
ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(loc="lower right",frameon=False,fontsize=10)
ax.set_title("Cumulative Response Rate by Treatment (1 - KM)",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("004_kaplan-meier_increasing.pdf",bbox_inches="tight"); fig.savefig("004_kaplan-meier_increasing.png",bbox_inches="tight",dpi=150)
print("Saved 004_kaplan-meier_increasing.pdf / .png")
