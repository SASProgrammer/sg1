"""
graph.py -- Example 054: Bar chart with error bars demonstrating the title/footnote system.
In Python, titles/footnotes are passed directly as function parameters.
Run build_data.py first.
"""
import pandas as pd, numpy as np, matplotlib.pyplot as plt

# Simulate the TitleKey / TNFSet system: titles and footnotes defined here
TITLES = {
    "title1": "Study XYZ — Gilead Sciences",
    "title2": "Protocol ABC-123",
    "title3": "Figure 1. Incidence (%) of Adverse Events by Category",
    "title4": "Safety Population",
}
FOOTNOTES = {
    "fn1": "Source: 054_tnfset_titlekey_example_043.py",
    "fn2": "AE=Adverse Event. CI=95% Confidence Interval (Wilson method).",
}

df = pd.read_csv("test_data.csv"); cats = df["category"].unique(); trts = sorted(df["trt"].unique())
colors = ["black", "#377EB8", "#E41A1C"]; x = np.arange(len(cats)); width = 0.25

fig, ax = plt.subplots(figsize=(11, 7))
for i, trt in enumerate(trts):
    sub = df[df["trt"] == trt].set_index("category").reindex(cats)
    ax.bar(x + i * width, sub["pct"], width, label=trt, color=colors[i], edgecolor="white")
    ax.errorbar(x + i * width, sub["pct"], yerr=[sub["pct"] - sub["ci_lo"], sub["ci_hi"] - sub["pct"]],
                fmt="none", ecolor="gray", elinewidth=1.5, capsize=3)

ax.set_xlabel("Adverse Event Category", fontsize=11, fontweight="bold")
ax.set_ylabel("Incidence (%)", fontsize=11, fontweight="bold")
ax.set_xticks(x + width); ax.set_xticklabels(cats, rotation=30, ha="right"); ax.set_ylim(0, 75)
ax.spines["top"].set_visible(False); ax.spines["right"].set_visible(False)
ax.legend(frameon=False, fontsize=10)

# Apply title system
fig.suptitle(TITLES["title3"], fontsize=13, fontweight="bold", y=0.98)
ax.set_title(f"{TITLES['title1']} | {TITLES['title2']}\n{TITLES['title4']}", fontsize=9, color="gray")
fig.text(0.01, 0.01, "\n".join(FOOTNOTES.values()), fontsize=8, color="gray", ha="left")
fig.tight_layout(rect=[0, 0.06, 1, 0.96])

fig.savefig("054_tnfset_titlekey_example_043.pdf", bbox_inches="tight")
fig.savefig("054_tnfset_titlekey_example_043.png", bbox_inches="tight", dpi=150)
print("Saved 054_tnfset_titlekey_example_043.pdf / .png")
