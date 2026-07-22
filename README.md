# 🛠️ Google Play Store Apps — Data Engineering & Pipeline

An end-to-end data engineering and analysis pipeline to profile, cleanse, transform, and derive insights from the Google Play Store apps ecosystem.

---

## 1. Initial Structural Findings & Diagnostics

A deep profiling run of the raw dataset (`googleplaystore.csv`) revealed the following:

- **Initial Shape:** 10,841 rows × 13 columns

### Mismatched / Malformed Data Types

| Column | Issue | Fix Applied |
|---|---|---|
| **Reviews** | Ingested as text due to stray characters and shifted columns | Converted to integer |
| **Size** | Mixed units (`M`, `k`) and `Varies with device` strings | Standardized to numeric KB |
| **Installs** | Comma separators and `+` suffixes | Stripped to integer |
| **Price** | Currency symbol (`$`) | Cleaned to float |

### Missing Value Strategy

| Column | Missing | % Missing | Action | Justification |
| :--- | :--- | :--- | :--- | :--- |
| **Rating** | 1,474 | 13.59% | Median imputation | Above 10% threshold — dropping rows would bias the sample. Imputed at ~4.3. |
| **Size** | 1,695 | 15.63% | Median imputation | Above 10% threshold — converted to KB, then imputed including 'Varies with device' rows. |
| **Type** | 1 | <0.01% | Row dropped | Negligible volume impact. |
| **Content Rating** | 1 | <0.01% | Row dropped | Ensures schema consistency. |
| **Current Ver** | 8 | 0.07% | Row dropped | Marginal — avoids synthetic data. |
| **Android Ver** | 3 | 0.02% | Row dropped | Extremely sparse. |

---

## 2. Outlier Treatment

Outliers identified using IQR bounds: `[Q1 − 1.5×IQR, Q3 + 1.5×IQR]`

- **Price:** Extreme values (e.g., $400 apps) capped via **winsorization** rather than dropped, to preserve valid high-tier pricing entries.
- **Reviews:** High variance between viral and long-tail apps — **capped** to reduce skew while retaining distribution shape.

---

## 3. Key Insights

1. **Market Density** — `FAMILY` and `GAME` categories together account for **over 20%** of all listed apps.
2. **Rating Skew** — Median rating sits at **4.3**, indicating strong left skew and possible platform selection bias.
3. **Pricing Model** — **92%+** of apps are free (`$0.00`).
4. **Size vs. Rating** — Weak correlation; apps from 10MB–100MB consistently score 4.0+.
5. **Pricing Outliers** — Novelty apps (e.g., the "I Am Rich" series) pushed prices up to **$399.99**, confirming the need for capping.

---

## 4. Repository Structure

```
google-play-analysis/
├── data/
│   └── googleplaystore.csv              # Original dataset
├── notebooks/
│   └── google_play_data_analysis.ipynb  # End-to-end analysis
├── queries.sql                          # Required SQL queries
├── requirements.txt                     # Python dependencies
└── README.md                            # Documentation
```

---

## 5. Setup

```bash
git clone https://github.com/pramodj551-oss/google-play-analysis.git
cd google-play-analysis
pip install -r requirements.txt
```

---

## 📬 Contact

**Pramod Prakash Jadhav**
📧 pramodj551@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/pramod-prakash-jadhav-42ba2281)
