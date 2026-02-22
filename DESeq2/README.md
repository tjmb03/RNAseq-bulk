# RNA-seq Interactive Analysis App (Shiny)

An interactive Shiny application for exploratory RNA-seq data analysis and visualization.

Designed to provide a lightweight, reproducible interface for differential expression exploration and expression-level visualization.

---

## Structure

<img width="283" height="117" alt="Screenshot 2026-02-14 at 1 37 41 PM" src="https://github.com/user-attachments/assets/22c9ddc8-4b2a-4bc3-ad84-3a3913cb5015" />


---

## Features

- RNA-seq expression visualization
- Interactive filtering
- Differential expression result exploration
- Dynamic plotting
- Reproducible analysis interface

---

## Technical Stack

- R ≥ 4.2  
- shiny  
- ggplot2  
- dplyr  
- DESeq2 (if applicable)

Install core dependencies:

```r
install.packages(c("shiny", "ggplot2", "dplyr"))
if (!require("BiocManager")) install.packages("BiocManager")
BiocManager::install("DESeq2")
