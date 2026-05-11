"""graph.py -- Example 002: Paneled KM curves (one panel per stratum). Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
try: from lifelines import KaplanMeierFitter
except ImportError: raise ImportError("pip install lifelines")

df=pd.read_csv("test_data.csv"); strata=sorted(df["stratum"].unique()); trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; ltys=["-","--","-."]
fig,axes=plt.subplots(1,len(strata),figsize=(5*len(strata),6),sharey=True)
for ax,strat in zip(axes,strata):
    for i,trt in enumerate(trts):
        sub=df[(df["stratum"]==strat)&(df["trt"]==trt)]
        kmf=KaplanMeierFitter()
        kmf.fit(sub["time"],event_observed=sub["event"],label=trt)
        kmf.plot_survival_function(ax=ax,ci_show=True,color=colors[i],linestyle=ltys[i],linewidth=2)
    ax.set_title(f"Stratum: {strat}",fontweight="bold"); ax.set_xlabel("Time (Months)"); ax.set_xlim(0,24); ax.set_xticks(range(0,25,4))
    ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y,_:f"{y:.0%}")); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
axes[0].set_ylabel("Survival Probability")
handles,labels=axes[0].get_legend_handles_labels()
[ax.get_legend().remove() for ax in axes if ax.get_legend()]
fig.legend(handles,labels,loc="lower center",ncol=3,frameon=False)
fig.suptitle("KM Survival by Treatment and Stratum",fontsize=13,fontweight="bold")
fig.tight_layout(rect=[0,0.06,1,1])
fig.savefig("002_kaplan_meier_panel.pdf",bbox_inches="tight"); fig.savefig("002_kaplan_meier_panel.png",bbox_inches="tight",dpi=150)
print("Saved 002_kaplan_meier_panel.pdf / .png")
