"""
graph.py  --  Example 007: Mean panels with consistent Y-axis scale
Creates one subplot per lab test; all panels share the same Y axis range.
Run build_data.py first.
"""

import sys
import pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parents[2] / "python"))

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from scipy import stats

df = pd.read_csv("test_data.csv")

labs    = df["labtest"].unique()
trts    = sorted(df["trt"].unique())
weeks   = sorted(df["week"].unique())
colors  = ["black", "#377EB8", "#E41A1C"]
markers = ["o", "s", "^"]
ltys    = ["-", "--", "-."]

# Compute stats per lab × trt × week
alpha = 0.05
summary_records = []
for lab in labs:
    for trt in trts:
        for wk in weeks:
            sub = df[(df["labtest"] == lab) & (df["trt"] == trt) & (df["week"] == wk)]["result"].dropna()
            n = len(sub)
            if n == 0:
                continue
            m  = sub.mean()
            se = sub.std(ddof=1) / np.sqrt(n) if n > 1 else 0
            t  = stats.t.ppf(1 - alpha / 2, df=n - 1) if n > 1 else 0
            summary_records.append({
                "labtest": lab, "trt": trt, "week": wk,
                "center": m, "q1": m - se * t, "q3": m + se * t, "n": n,
            })

sdf = pd.DataFrame(summary_records)

# Global Y range for consistent axis
y_min = sdf["q1"].min()
y_max = sdf["q3"].max()
y_pad = (y_max - y_min) * 0.05

fig, axes = plt.subplots(1, len(labs), figsize=(5 * len(labs), 6), sharey=True)
if len(labs) == 1:
    axes = [axes]

for ax, lab in zip(axes, labs):
    for i, trt in enumerate(trts):
        grp = sdf[(sdf["labtest"] == lab) & (sdf["trt"] == trt)].sort_values("week")
        ax.plot(grp["week"], grp["center"], marker=markers[i], color=colors[i],
                linestyle=ltys[i], linewidth=2, label=trt)
        ax.errorbar(grp["week"], grp["center"],
                    yerr=[grp["center"] - grp["q1"], grp["q3"] - grp["center"]],
                    fmt="none", ecolor=colors[i], elinewidth=1.5, capsize=0)
    ax.set_title(lab, fontsize=11, fontweight="bold")
    ax.set_xlabel("Study Week", fontsize=10)
    ax.set_xticks(weeks)
    ax.set_ylim(y_min - y_pad, y_max + y_pad)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

axes[0].set_ylabel("Mean Result (95% CI)", fontsize=10)
handles, labels = axes[0].get_legend_handles_labels()
fig.legend(handles, labels, loc="upper right", fontsize=9, frameon=False)
fig.suptitle("Mean Lab Results Over Time by Treatment (Consistent Y Axis)", fontsize=13, fontweight="bold")
fig.tight_layout()

fig.savefig("007_mean_panel_consistent_Y.pdf", bbox_inches="tight")
fig.savefig("007_mean_panel_consistent_Y.png", bbox_inches="tight", dpi=150)
print("Saved 007_mean_panel_consistent_Y.pdf / .png")
