"""graph.py -- Example 045: Vertical bar panels by visit. Run build_data.py first."""
import pandas as pd, matplotlib.pyplot as plt
df=pd.read_csv("test_data.csv"); visits=sorted(df["visit"].unique()); trts=sorted(df["trt"].unique())
colors=["black","#377EB8","#E41A1C"]; fig,axes=plt.subplots(1,len(visits),figsize=(3.5*len(visits),6),sharey=True)
for ax,vis in zip(axes,visits):
    sub=df[df["visit"]==vis]; ax.bar(range(len(trts)),[sub[sub["trt"]==t]["pct"].values[0] for t in trts],color=colors,edgecolor="white")
    ax.set_xticks(range(len(trts))); ax.set_xticklabels([t.replace("Drug A ","") for t in trts],rotation=30,ha="right"); ax.set_title(f"Week {vis}",fontweight="bold"); ax.set_ylim(0,70)
    ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
axes[0].set_ylabel("Response Rate (%)",fontsize=11)
fig.suptitle("Response Rate by Treatment — Panels by Visit",fontsize=13,fontweight="bold"); fig.tight_layout()
fig.savefig("045_vertical_bar_chart_panel.pdf",bbox_inches="tight"); fig.savefig("045_vertical_bar_chart_panel.png",bbox_inches="tight",dpi=150)
print("Saved 045_vertical_bar_chart_panel.pdf / .png")
