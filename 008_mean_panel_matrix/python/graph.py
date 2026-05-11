"""
graph.py  --  Example 008: Mean panels in 2x2 matrix layout
Panels: Hemoglobin Early, Hemoglobin Late, Creatinine, ALT.
Run build_data.py first.
"""

import sys
import pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parents[2] / "python"))

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

df = pd.read_csv("test_data.csv")

trts    = sorted(df["trt"].unique())
colors  = ["black", "#377EB8", "#E41A1C"]
markers = ["o", "s", "^"]
ltys    = ["-", "--", "-."]
alpha   = 0.05


def compute_stats(sub_df, xvar="week"):
    rows = []
    for trt in trts:
        for wk in sorted(sub_df[xvar].unique()):
            y = sub_df[(sub_df["trt"] == trt) & (sub_df[xvar] == wk)]["result"].dropna()
            n = len(y)
            if n == 0:
                continue
            m  = y.mean()
            se = y.std(ddof=1) / np.sqrt(n) if n > 1 else 0
            tc = stats.t.ppf(1 - alpha / 2, df=n - 1) if n > 1 else 0
            rows.append({"trt": trt, xvar: wk, "center": m, "q1": m - se * tc, "q3": m + se * tc, "n": n})
    return pd.DataFrame(rows)


panels = [
    ("Hemoglobin\n(Weeks 0–12)", df[(df["labtest"] == "Hemoglobin") & (df["week"] <= 12)]),
    ("Hemoglobin\n(Weeks 12–24)", df[(df["labtest"] == "Hemoglobin") & (df["week"] >= 12)]),
    ("Creatinine", df[df["labtest"] == "Creatinine"]),
    ("ALT",        df[df["labtest"] == "ALT"]),
]

fig, axes = plt.subplots(2, 2, figsize=(12, 9))
axes = axes.flatten()

for ax, (title, pdata) in zip(axes, panels):
    sdf = compute_stats(pdata)
    for i, trt in enumerate(trts):
        grp = sdf[sdf["trt"] == trt].sort_values("week")
        ax.plot(grp["week"], grp["center"], marker=markers[i], color=colors[i],
                linestyle=ltys[i], linewidth=2, label=trt)
        ax.errorbar(grp["week"], grp["center"],
                    yerr=[grp["center"] - grp["q1"], grp["q3"] - grp["center"]],
                    fmt="none", ecolor=colors[i], elinewidth=1.5)
    ax.set_title(title, fontweight="bold")
    ax.set_xlabel("Study Week")
    ax.set_ylabel("Mean (95% CI)")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

handles, labels = axes[0].get_legend_handles_labels()
fig.legend(handles, labels, loc="lower center", ncol=3, fontsize=9, frameon=False)
fig.suptitle("Mean Lab Results — Panel Matrix Layout", fontsize=13, fontweight="bold")
fig.tight_layout(rect=[0, 0.06, 1, 1])

fig.savefig("008_mean_panel_matrix.pdf", bbox_inches="tight")
fig.savefig("008_mean_panel_matrix.png", bbox_inches="tight", dpi=150)
print("Saved 008_mean_panel_matrix.pdf / .png")
