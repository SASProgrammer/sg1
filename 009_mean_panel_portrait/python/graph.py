"""
graph.py  --  Example 009: Mean panels in portrait (vertical) layout
3 lab tests stacked vertically in one figure.
Run build_data.py first.
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

df = pd.read_csv("test_data.csv")

labs    = ["Hemoglobin", "Creatinine", "ALT"]
trts    = sorted(df["trt"].unique())
weeks   = sorted(df["week"].unique())
colors  = ["black", "#377EB8", "#E41A1C"]
markers = ["o", "s", "^"]
ltys    = ["-", "--", "-."]
alpha   = 0.05

fig, axes = plt.subplots(len(labs), 1, figsize=(8, 4 * len(labs)), sharex=True)

for ax, lab in zip(axes, labs):
    for i, trt in enumerate(trts):
        rows = []
        for wk in weeks:
            y = df[(df["labtest"] == lab) & (df["trt"] == trt) & (df["week"] == wk)]["result"].dropna()
            n = len(y)
            if n == 0:
                continue
            m  = y.mean()
            se = y.std(ddof=1) / np.sqrt(n) if n > 1 else 0
            tc = stats.t.ppf(1 - alpha / 2, df=n - 1) if n > 1 else 0
            rows.append({"week": wk, "center": m, "q1": m - se * tc, "q3": m + se * tc})
        grp = pd.DataFrame(rows)
        ax.plot(grp["week"], grp["center"], marker=markers[i], color=colors[i],
                linestyle=ltys[i], linewidth=2, label=trt)
        ax.errorbar(grp["week"], grp["center"],
                    yerr=[grp["center"] - grp["q1"], grp["q3"] - grp["center"]],
                    fmt="none", ecolor=colors[i], elinewidth=1.5)
    ax.set_ylabel(f"{lab}\nMean (95% CI)", fontsize=10)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

axes[-1].set_xlabel("Study Week", fontsize=11)
axes[-1].set_xticks(weeks)
handles, labels = axes[0].get_legend_handles_labels()
fig.legend(handles, labels, loc="upper right", fontsize=9, frameon=False)
fig.suptitle("Mean Lab Results Over Time — Portrait Layout", fontsize=13, fontweight="bold")
fig.tight_layout()

fig.savefig("009_mean_panel_portrait.pdf", bbox_inches="tight")
fig.savefig("009_mean_panel_portrait.png", bbox_inches="tight", dpi=150)
print("Saved 009_mean_panel_portrait.pdf / .png")
