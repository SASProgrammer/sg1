"""graph.py -- Example 044: Histogram with normal density overlay. Run build_data.py first."""
import pandas as pd, numpy as np, matplotlib.pyplot as plt
from scipy import stats as sc
df=pd.read_csv("test_data.csv"); vals=df["value"]
mu,sigma=vals.mean(),vals.std(ddof=1); bins=np.arange(0,101,10)
fig,ax=plt.subplots(figsize=(9,6))
n,b,_=ax.hist(vals,bins=bins,color="lightsteelblue",edgecolor="white",label="Observed")
# Scale normal density to histogram bin count
bin_width=10; scale_factor=len(vals)*bin_width
x=np.linspace(0,100,200); density=sc.norm.pdf(x,mu,sigma)*scale_factor
ax.plot(x,density,"r-",linewidth=2.5,label=f"Normal (μ={mu:.1f}, σ={sigma:.1f})")
ax.set_xlabel("Value",fontsize=12,fontweight="bold"); ax.set_ylabel("Frequency",fontsize=12,fontweight="bold")
ax.set_xticks(range(0,101,10)); ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(frameon=False); ax.set_title("Histogram with Normal Density Overlay",fontsize=13,fontweight="bold")
fig.tight_layout(); fig.savefig("044_histogram_with_line_chart.pdf",bbox_inches="tight"); fig.savefig("044_histogram_with_line_chart.png",bbox_inches="tight",dpi=150)
print("Saved 044_histogram_with_line_chart.pdf / .png")
