# RNAseq-bulk

A collection of tools for bulk RNA-seq differential expression analysis, including an interactive Shiny application and a DESeq2 analysis pipeline.

---

## Repository Structure

```
RNAseq-bulk/
├── Bulk-RNAseq_shiny/   # Interactive Shiny app for DE analysis
├── DESeq2/              # Standalone DESeq2 analysis scripts
└── .github/workflows/   # CI/CD workflows
```

---

## Components

### 🖥️ Bulk-RNAseq_shiny

An interactive R Shiny application for differential expression analysis. Upload your count matrix and sample metadata, configure your contrast, and explore results across three statistical frameworks — no coding required.

**Features:**
- Three DE algorithms — DESeq2, edgeR (TMM + QLF), and limma-voom
- QC dashboard — library sizes, gene detection, RLE plot, PCA, and distance heatmap
- Volcano and MA plots with adjustable significance thresholds
- Algorithm comparison via Venn diagram and consensus gene table
- Pathway analysis — GO, KEGG, and GSEA
- Downloadable results (CSV) and full HTML report

See [`Bulk-RNAseq_shiny/`](Bulk-RNAseq_shiny) folder for full usage and installation instructions.

---

### 📊 DESeq2

A standalone DESeq2 differential expression pipeline for command-line or script-based analysis.

See the [`DESeq2/`](DESeq2/) folder for scripts and usage details.

---
> © 2026 tjmb03. This project is provided for educational and methodological
demonstration purposes. Source code for the interactive dashboards is **available on request** for academic and research use.
