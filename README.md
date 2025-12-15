# Decomposing the Ontario Gender Wage Gap: A Micro-Econometric Analysis

**Author:** Zil Cheema  
**Tools:** R, Oaxaca-Blinder Decomposition, Tidyverse  
**Data Source:** Statistics Canada SLID (via `carData`)

---

## 📌 Project Overview
This project applies the **Oaxaca-Blinder decomposition method** to investigate the structural determinants of the gender wage gap in Ontario, Canada. Using microdata from the *Survey of Labour and Income Dynamics* (SLID), I isolate how much of the wage differential is attributable to observable skills ("Endowments") versus structural labor market factors ("Coefficients").

The goal is to answer a key policy question: **"Is the gender wage gap caused by a lack of education/experience among women, or by how those skills are valued in the market?"**

## 📊 Key Findings

| Component | Estimate | Interpretation |
| :--- | :--- | :--- |
| **Endowments (Blue)** | **0.001** | **Near Zero.** Men and women in this sample have statistically identical levels of human capital (Education/Age). |
| **Coefficients (Red)** | **0.009** | **Dominant.** The majority of the gap remains even after controlling for skills, suggesting structural drivers (e.g., occupational sorting or discrimination). |

**Policy Implication:**
Since the "Endowment Effect" is negligible, policy interventions focused solely on "increasing access to education" for women may yield diminishing returns. The gap is primarily structural, suggesting a need for policies addressing pay equity, occupational segregation, or childcare penalties.

## 📉 Visualization
*(Upload the image we created, name it `wage_gap_plot.png`, and it will appear here)*
![Wage Gap Decomposition Chart](wage_gap_plot.png)

## 🧠 Methodology
The analysis uses the standard **Blinder-Oaxaca** technique to decompose the mean difference in log wages between two groups (Men and Women).

The wage equation is modeled as:
$$\ln(Wage) = \beta_0 + \beta_1(Education) + \beta_2(Age) + \epsilon$$

The decomposition splits the gap ($R$) into:
1.  **Endowments ($E$):** The portion due to group differences in predictors (e.g., education years).
2.  **Coefficients ($C$):** The portion due to differences in the estimated $\beta$ parameters (returns to skills).
3.  **Interaction ($I$):** The simultaneous effect of differences in endowments and coefficients.

## 🛠️ Tech Stack & Code Structure
* **Language:** R
* **Libraries:**
    * `oaxaca`: For the econometric decomposition.
    * `tidyverse` (`dplyr`, `ggplot2`): For data cleaning and visualization.
    * `carData`: Source of the SLID dataset.

### Code Snippet: The Model
```r
# Define the wage model: Log Wages explained by Education and Age
# Split the regression by Gender (is_male)
results_real <- oaxaca(log(wages) ~ education + age | is_male, data = real_data)

# Extract the decomposition results
vals <- results_real$threefold$overall
