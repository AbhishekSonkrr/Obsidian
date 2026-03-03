---

tags:

- report

- bash

- automation

- mnnit

date: 2026-03-03

author: Abhishek Sonkar

status: completed

---

  

# Process Log: IEEE Technical Report Generation

  

> [!abstract] Overview

> This document outlines the systematic process and specific commands used to generate the IEEE technical report on **[[File Automation using the Bash Shell]]**.

  

## 1. Research and Planning

- **Topic Selection**: Researched scientific/engineering domains where Bash automation is critical. Settled on "Atmospheric Sensor Data Preprocessing".

- **Template Identification**: Verified the structure of the `IEEEtran` document class.

- **Visual Mapping**: Planned for a system flowchart and a performance comparison graph.

  

## 2. Asset Generation

> [!info] Visuals

> - **Flowchart**: [[flowchart.png]]
> - **Performance Graph**: [[performance_graph.png]]

  

## 3. LaTeX Drafting & Expansion

- **Initial Draft**: Wrote the core structure (Abstract, Intro, Methodology, Case Study, Bib).

- **Expansion**: To meet the **3-page requirement**, added a comparison table (`tabular`), expanded the "Methodology" with more technical depth, and added a "Discussion" section on reproducibility.

  

## 4. Environment Setup (Arch Linux)

> [!caution] sudo Required

> Installed the full TeX Live suite using `pacman`.

  

**Commands Executed:**

```bash

# Verify package manager

which pacman

  

# Search for packages

pacman -Ss texlive-core

  

# Full Installation

echo "8511" | sudo -S pacman -S --noconfirm \

texlive-basic \

texlive-bin \

texlive-latex \

texlive-latexextra \

texlive-publishers \

texlive-fontsrecommended \

texlive-fontsextra

```

  

## 5. Compilation Process

The report was compiled using `pdflatex` to generate [[report.pdf]].

  

**Commands Executed:**

```bash

# Compilation Pass (Run twice for cross-refs)

pdflatex -interaction=nonstopmode report.tex

pdflatex -interaction=nonstopmode report.tex

```

  

## 6. Project Finalization

- **Author Update**: Applied specific user details (Abhishek Sonkar, MNNIT Allahabad).

- **Verification**: Confirmed the final PDF is 3 pages long.

  

---

**Related**: [[walkthrough.md]], [[report.tex]]