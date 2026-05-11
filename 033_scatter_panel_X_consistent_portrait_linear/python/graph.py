"""graph.py -- Example 033: Scatter panels, consistent X, portrait (3 rows × 1 col). Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt; from scipy import stats
df=pd.read_csv("test_data.csv"); panels=["Visit 1","Visit 2","Visit 3"]; trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]
x_min,x_max=df["x_val"].min()-2,df["x_val"].max()+2
fig,axes=plt.subplots(3,1,figsize=(7,13),sharex=True)
for ax,panel in zip(axes,panels):
    sub_all=df[df["panel"]==panel]
    for i,trt in enumerate(trts):
        sub=sub_all[sub_all["trt"]==trt]; ax.scatter(sub["x_val"],sub["y_val"],color=colors[i],marker=markers[i],alpha=.7,s=35,label=trt)
    sl,ic,r,_,_=stats.linregress(sub_all["x_val"],sub_all["y_val"]); x_l=np.array([x_min,x_max])
    ax.plot(x_l,sl*x_l+ic,"k--",linewidth=1.2); ax.set_ylabel(f"{panel}\nEndpoint (y)",fontsize=10)
    ax.text(.98,.95,f"r={r:.2f}",ha="right",va="top",transform=ax.transAxes,fontsize=9)
    ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
axes[-1].set_xlabel("Baseline (x)",fontsize=11); axes[-1].set_xlim(x_min,x_max)
handles,labels=axes[0].get_legend_handles_labels(); fig.legend(handles,labels,loc="upper right",frameon=False)
fig.suptitle("Scatter Panels — Consistent X Axis (Portrait)",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("033_scatter_panel_X_consistent_portrait_linear.pdf",bbox_inches="tight"); fig.savefig("033_scatter_panel_X_consistent_portrait_linear.png",bbox_inches="tight",dpi=150)
print("Saved 033.")
