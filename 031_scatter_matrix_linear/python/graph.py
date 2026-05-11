"""graph.py -- Example 031: Scatter matrix. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt
from scipy import stats
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique())
yvars=[("y1","Endpoint 1"),("y2","Endpoint 2"),("y3","Endpoint 3")]
colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]
fig,axes=plt.subplots(1,3,figsize=(15,6))
for ax,(yv,yl) in zip(axes,yvars):
    for i,trt in enumerate(trts):
        sub=df[df["trt"]==trt]; ax.scatter(sub["x_val"],sub[yv],color=colors[i],marker=markers[i],alpha=.7,s=40,label=trt if ax==axes[0] else "")
    sl,ic,r,_,_=stats.linregress(df["x_val"],df[yv]); x_l=np.linspace(df["x_val"].min(),df["x_val"].max(),100)
    ax.plot(x_l,sl*x_l+ic,"k--",linewidth=1.2); ax.set_title(f"{yl} (r={r:.2f})",fontweight="bold")
    ax.set_xlabel("Baseline (x)"); ax.set_ylabel(yl); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
handles,labels=axes[0].get_legend_handles_labels(); fig.legend(handles,labels,loc="lower center",ncol=3,frameon=False)
fig.suptitle("Scatter Plot Matrix — Endpoints vs. Baseline",fontsize=13,fontweight="bold")
fig.tight_layout(rect=[0,0.06,1,1]); fig.savefig("031_scatter_matrix_linear.pdf",bbox_inches="tight"); fig.savefig("031_scatter_matrix_linear.png",bbox_inches="tight",dpi=150)
print("Saved 031_scatter_matrix_linear.pdf / .png")
