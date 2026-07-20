# Google Play Store Apps Data Engineering & Pipeline
An end-to-end data engineering and analysis infrastructure designed to profile, ingest, cleanse, transform, and draw insights from the Google Play Store apps ecosystem.
---
## 1. Initial Structural Findings & Diagnostics
A deep profiling run of the raw dataset (`googleplaystore.csv`) revealed structural anomalies:
* **Initial Shape:** 10,841 rows and 13 columns.
* **Mismatched / Malformed Data Types:**
  * `Reviews`: Ingested as an Object (text string) due to stray alphabetical characters and shifted columns. Needs transformation to an integer.
  * `Size`: Represented as strings incorporating unit markers (`M` for Megabytes, `k` for Kilobytes) alongside textual variations (`Varies with device`). Needs standardization into unified numeric Kilobytes (KB).
  * `Installs`: Formatted with comma separators and suffix symbols (`+`). Must be stripped to integer numeric representations.
  * `Price`: String data type including currency tracking signs (`$`). Requires cleaning to float representations.
### Per-Column Cleaning & Missing Value Management Strategy

| Column Name | Missing Count | % Missing | Strategic Action Taken | Decision Justification |
| :--- | :--- | :--- | :--- | :--- |
| **Rating** | 1,474 | 13.59% | **Imputation (Median)** | Exceeds the 10% threshold. Dropping rows would induce a severe sample reduction bias. Imputed using the column median (~4.3) to preserve analytical continuity. |
| **Size** | 1,695 | 15.63% | **Imputation (Median)** | Exceeds the 10% threshold. Converted string attributes to consistent numerical formats (KB) and substituted missing values and 'Varies with device' rows with the column median. |
| **Type** | 1 | < 0.01% | **Row Omission** | Sub-threshold value. Drop strategy applied as it has no material impact on dataset volume or validity. |
| **Content Rating** | 1 | < 0.01% | **Row Omission** | Negligible missing rate. Removed affected row to guarantee schema consistency. |
| **Current Ver** | 8 | 0.07% | **Row Omission** | Marginal missing instances. Row removal preserves clean data structure without introducing synthetic data. |
| **Android Ver** | 3 | 0.02% | **Row Omission** | Extremely sparse missing data; handled via direct row omission. |

---
## 2. Outlier Treatment Execution
Outliers were identified using the Interquartile Range (IQR) metric ($\text{IQR} = Q_3 - Q_1$), setting evaluation boundaries at $[Q_1 - 1.5 \times \text{IQR}, Q_3 + 1.5 \times \text{IQR}]$.
* **Price Variable:** Extreme anomalies discovered (e.g., junk applications priced at $400). Removing rows entirely would discard valid, high-tier pricing schemes. A **capping (winsorization)** approach was executed, anchoring values beyond the upper threshold to the dynamic computational bound.
* **Reviews Variable:** High distribution variance spanning viral apps versus long-tail items. Executed **capping** to tame exponential distribution skew while retaining structural patterns in subsequent visualizations.
---
## 3. Data-Grounded Project Insights
The following observations were drawn from the systematic cleaning and analytical pipeline:
* **Insight 1 (Market Density Dynamics):** App volume distribution is highly concentrated. The **FAMILY** and **GAME** categories constitute the largest market share, combined accounting for **over 20%** of total applications indexed across the store ecosystem.
* **Insight 2 (User Satisfaction Skew):** The overall rating profile across the digital marketplace exhibits a heavy left skew. The calculated **median rating sits prominently at 4.3**, pointing to either generalized positive consumer feedback or platform selection bias.
* **Insight 3 (Pricing Structures):** Free application strategies heavily dominate the ecosystem. Over **92% of active applications** deployed across the marketplace leverage completely free tier access models ($0.00 entries).
* **Insight 4 (Software Scale vs. Performance):** Mapping file sizes against consumer scores indicates that application footprint scale in Kilobytes has low correlation with ratings. Apps ranging from 10MB up to 100MB consistently secure stable 4.0+ scoring evaluations.
* **Insight 5 (Economic Outlier Imbalances):** The outlier analysis exposed an economic anomaly where specific, low-utility components ("I Am Rich" app series) artificialized pricing spreads up to **$399.99**, validating the need for the data capping strategies implemented.
---
## 4. Project Repository Structure
                       
google-play-analysis/
├── data/
│   └── googleplaystore.csv              # Original downloaded dataset
├── notebooks/
│   └── google_play_data_analysis.ipynbb # Complete end-to-end Python execution
├── queries.sql                          # Pure SQL file containing the 6 required queries
├── requirements.txt                     # Python package dependencies
└── README.md                            # Structure, decisions, and data-grounded insights

pip install -r requirements.txt
