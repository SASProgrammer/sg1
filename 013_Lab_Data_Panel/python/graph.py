"""graph.py -- Example 013: Paneled lab data (3 panels, one per lab test). Run build_data.py first."""
import numpy as np, pandas as pd, matplotlib.pyplot as plt
from scipy import stats

df=pd.read_csv("test_data.csv")
labs=["ALT","Creatinine","Hemoglobin"]; trts=sorted(df["trt"].unique())
visits=sorted(df["visit"].unique()); colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]; ltys=["-","--","-."]
alpha=0.05

fig,axes=plt.subplots(1,3,figsize=(15,6))
for ax,lab in zip(axes,labs):
    for i,trt in enumerate(trts):
        rows=[]
        for v in visits:
            y=df[(df["labtest"]==lab)&(df["trt"]==trt)&(df["visit"]==v)]["lbresult"].dropna()
            n=len(y)
            if n==0: continue
            m=y.mean(); se=y.std(ddof=1)/np.sqrt(n) if n>1 else 0; tc=stats.t.ppf(1-alpha/2,df=n-1) if n>1 else 0
            rows.append({"visit":v,"center":m,"q1":m-se*tc,"q3":m+se*tc,"n":n})
        grp=pd.DataFrame(rows)
        ax.plot(grp["visit"],grp["center"],marker=markers[i],color=colors[i],linestyle=ltys[i],linewidth=2,label=trt)
        ax.errorbar(grp["visit"],grp["center"],yerr=[grp["center"]-grp["q1"],grp["q3"]-grp["center"]],fmt="none",ecolor=colors[i],elinewidth=1.5)
    ax.set_title(lab,fontweight="bold"); ax.set_xlabel("Study Visit"); ax.set_ylabel("Mean (95% CI)")
    ax.set_xticks(visits); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)

handles,labels=axes[0].get_legend_handles_labels()
fig.legend(handles,labels,loc="upper center",ncol=3,fontsize=9,frameon=False)
fig.suptitle("Mean Lab Results by Treatment — Paneled",fontsize=13,fontweight="bold")
fig.tight_layout(rect=[0,0,1,0.93])
fig.savefig("013_Lab_Data_Panel.pdf",bbox_inches="tight")
fig.savefig("013_Lab_Data_Panel.png",bbox_inches="tight",dpi=150)
print("Saved 013_Lab_Data_Panel.pdf / .png")
