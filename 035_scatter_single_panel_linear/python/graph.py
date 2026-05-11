"""graph.py -- Example 035: Single scatter with linear regression. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt
from scipy import stats
df=pd.read_csv("test_data.csv"); trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; markers=["o","s","^"]
fig,ax=plt.subplots(figsize=(8,7))
for i,trt in enumerate(trts):
    sub=df[df["trt"]==trt]
    ax.scatter(sub["x_val"],sub["y_val"],color=colors[i],marker=markers[i],alpha=0.7,label=trt,s=50)
# Overall regression line
slope,intercept,r,p,se=stats.linregress(df["x_val"],df["y_val"])
x_line=np.linspace(df["x_val"].min(),df["x_val"].max(),100)
ax.plot(x_line,slope*x_line+intercept,"k--",linewidth=1.5,label=f"Overall fit (r={r:.2f})")
ax.set_xlabel("Baseline Value (x)",fontsize=12,fontweight="bold"); ax.set_ylabel("Follow-up Value (y)",fontsize=12,fontweight="bold")
ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(loc="upper left",frameon=False,fontsize=9)
ax.set_title("Scatter Plot: Baseline vs. Follow-up with Linear Regression",fontsize=12,fontweight="bold")
fig.tight_layout(); fig.savefig("035_scatter_single_panel_linear.pdf",bbox_inches="tight"); fig.savefig("035_scatter_single_panel_linear.png",bbox_inches="tight",dpi=150)
print("Saved 035_scatter_single_panel_linear.pdf / .png")
