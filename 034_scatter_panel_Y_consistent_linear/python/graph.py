"""graph.py -- Example 034: Scatter panels, consistent Y axis. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt; from scipy import stats
df=pd.read_csv("test_data.csv"); panels=["Visit 1","Visit 2","Visit 3"]; trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]
y_min,y_max=df["y_val"].min()-3,df["y_val"].max()+3  # shared Y range
fig,axes=plt.subplots(1,3,figsize=(15,5),sharey=True)
for ax,panel in zip(axes,panels):
    sub_all=df[df["panel"]==panel]
    for i,trt in enumerate(trts):
        sub=sub_all[sub_all["trt"]==trt]; ax.scatter(sub["x_val"],sub["y_val"],color=colors[i],marker=markers[i],alpha=.7,s=35,label=trt)
    sl,ic,r,_,_=stats.linregress(sub_all["x_val"],sub_all["y_val"]); x_l=np.linspace(sub_all["x_val"].min(),sub_all["x_val"].max(),100)
    ax.plot(x_l,sl*x_l+ic,"k--",linewidth=1.2); ax.set_ylim(y_min,y_max); ax.set_title(f"{panel} (r={r:.2f})",fontweight="bold")
    ax.set_xlabel("Baseline (x)"); ax.set_ylabel("Endpoint (y)"); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
handles,labels=axes[0].get_legend_handles_labels(); fig.legend(handles,labels,loc="lower center",ncol=3,frameon=False)
fig.suptitle("Scatter Panels — Consistent Y Axis",fontsize=13,fontweight="bold")
fig.tight_layout(rect=[0,0.07,1,1]); fig.savefig("034_scatter_panel_Y_consistent_linear.pdf",bbox_inches="tight"); fig.savefig("034_scatter_panel_Y_consistent_linear.png",bbox_inches="tight",dpi=150)
print("Saved 034.")
