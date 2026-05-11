"""graph.py -- Example 032: Scatter panels, consistent X axis, landscape. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt; from scipy import stats
df=pd.read_csv("test_data.csv"); panels=["Visit 1","Visit 2","Visit 3"]; trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]
x_min,x_max=df["x_val"].min()-2,df["x_val"].max()+2  # shared X range
fig,axes=plt.subplots(1,3,figsize=(15,5),sharey=False)
for ax,panel in zip(axes,panels):
    sub_all=df[df["panel"]==panel]
    for i,trt in enumerate(trts):
        sub=sub_all[sub_all["trt"]==trt]; ax.scatter(sub["x_val"],sub["y_val"],color=colors[i],marker=markers[i],alpha=.7,s=35,label=trt)
    sl,ic,r,_,_=stats.linregress(sub_all["x_val"],sub_all["y_val"]); x_l=np.array([x_min,x_max])
    ax.plot(x_l,sl*x_l+ic,"k--",linewidth=1.2); ax.set_xlim(x_min,x_max); ax.set_title(f"{panel} (r={r:.2f})",fontweight="bold")
    ax.set_xlabel("Baseline (x)"); ax.set_ylabel("Endpoint (y)"); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
handles,labels=axes[0].get_legend_handles_labels(); fig.legend(handles,labels,loc="lower center",ncol=3,frameon=False)
fig.suptitle("Scatter Panels — Consistent X Axis (Landscape)",fontsize=13,fontweight="bold")
fig.tight_layout(rect=[0,0.07,1,1]); fig.savefig("032_scatter_panel_X_consistent_landscape_linear.pdf",bbox_inches="tight"); fig.savefig("032_scatter_panel_X_consistent_landscape_linear.png",bbox_inches="tight",dpi=150)
print("Saved 032_scatter_panel_X_consistent_landscape_linear.pdf / .png")
