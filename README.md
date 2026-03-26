# FerrIULândia Platform — Part 1

> **Operating Systems 2025/2026 — Practical Assignment (Part 1, Version 1)**  
> Department of Information Science and Technology — ISCTE-IUL  
> 2nd Semester | Deadline: **March 16, 2026 at 11:59 AM**

---

## Overview

**FerrIULândia** is a platform designed to optimize automobile parts recycling centres (scrapyards). It enables the registration of accepted material types with their respective prices, tracks sales transactions, and generates statistical reports.

This repository covers **Part 1** of the assignment, focused on building a set of **Bash shell scripts** for platform administration and management.

---

## Key Concepts

| Concept                   | Description                                                                                                                 |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Material Registration** | Only registered materials are accepted. Each material has a _type_, _price per kg_, and an optional _daily limit in kg_.    |
| **Sales Registration**    | Records seller name, material type, quantity in kg, and timestamp.                                                          |
| **Maintenance**           | Periodic task that checks if any material reached its daily limit the previous day and increases the limit by 100 kg if so. |
| **Statistics**            | Generates an HTML report with platform statistics.                                                                          |

---

## Scripts

### S1 — `regista_material.sh`

Registers a new material in the FerrIULândia platform.

**Usage:**

```bash
./regista_material.sh <Material> <Price per kg> [Daily limit]
```

**Examples:**

```bash
./regista_material.sh Ferro 1 1000
./regista_material.sh Aluminio 2
./regista_material.sh "Cobre Novo" 20
./regista_material.sh "Cobre Velho" 13 750
```

**Output file — `materiais.txt` format:**

```
<Material>;<Price per kg>;<Daily limit>
```

**Validation steps:**

| Step     | Description                                                                                                                      |
| -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **S1.1** | Validates argument count (2–3), material name length (≥ 2 chars), and that price and optional daily limit are positive integers. |
| **S1.2** | Checks if `materiais.txt` exists and is readable/writable. Checks if the material already exists (case-sensitive).               |
| **S1.3** | Adds the new material as a new line at the end of `materiais.txt`.                                                               |
| **S1.4** | Creates `materiais-ordenados-preco.txt` with all materials sorted by ascending price.                                            |

---

### S2 — `regista_venda.sh`

Registers a material sale in the FerrIULândia platform.

**Usage:**

```bash
./regista_venda.sh "<Seller name>" "<Material>" <Weight in kg>
```

**Examples:**

```bash
./regista_venda.sh "Miguel Tavares" "Cobre Novo" 12
./regista_venda.sh "Carlos Coutinho" Aluminio 53
./regista_venda.sh "Filipa Prudencio" Ferro 98
```

**Output file — `vendas.txt` format:**

```
<Seller name>;<Material>;<Weight in kg>;<Timestamp:yyyy-MM-ddTHH:mm>
```

**Validation steps:**

| Step     | Description                                                                                                                                                                                           |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **S2.1** | Validates exactly 3 arguments and that weight is a positive integer.                                                                                                                                  |
| **S2.2** | Checks `vendas.txt` access; validates material exists in `materiais.txt`; checks that the daily limit is not exceeded; validates seller name matches a current Tigre system user (first + last name). |
| **S2.3** | Appends the sale record to `vendas.txt`.                                                                                                                                                              |

---

### S3 — `manutencao.sh`

Periodic maintenance script — takes no arguments.

**Step S3.1 — Processing:**

- Validates `materiais.txt` exists and is readable/writable.
- If `vendas.txt` exists, validates it is readable.
- Checks if any material's total sales for the previous day exactly reached its daily limit. If so, increases that material's daily limit by **100 kg**.
- Reports `so_success` even if no material reached its limit.

**Step S3.2 — Scheduling via cron (`cron.def`):**

Configure the system to run `manutencao.sh` every day **Monday to Saturday** (including holidays) at **00:01**:

```
1 0 * * 1-6 /path/to/manutencao.sh
```

> The `cron.def` file must be submitted alongside the shell scripts.

---

### S4 — `stats.sh`

Generates an HTML statistics report for the platform.

**Usage:**

```bash
./stats.sh           # Runs all statistics (1 to 4) sequentially
./stats.sh 1         # Runs only Stat 1
./stats.sh 1 2       # Runs Stats 1 and 2 in order
./stats.sh 3 4 1     # Runs Stats 3, 4, and 1 in that order
```

**Step S4.1 — Validations:**

- Validates that `materiais.txt` and `vendas.txt` exist and are readable.
- Validates that the input arguments match the expected format.

**Step S4.2 — Statistics:**

| Stat       | Description                                                                 | HTML Tag           |
| ---------- | --------------------------------------------------------------------------- | ------------------ |
| **S4.2.1** | Material with the highest price per kg                                      | `<h2>Stats1:</h2>` |
| **S4.2.2** | Top 3 most traded materials by total kg in the current month                | `<h2>Stats2:</h2>` |
| **S4.2.3** | "King of scrap" from last month — seller with highest revenue per fewest kg | `<h2>Stats3:</h2>` |
| **S4.2.4** | Top 3 sellers by number of sales transactions in the current year           | `<h2>Stats4:</h2>` |

**Step S4.3 — Output file (`stats.html`) structure:**

```html
<html>
  <head>
    <meta charset="UTF-8" />
    <title>FerrIULândia: Estatísticas</title>
  </head>
  <body>
    <h1>Lista atualizada em YYYY-MM-DD HH:MM:SS</h1>
    [statistics HTML]
  </body>
</html>
```

---

### S5 — `menu.sh`

Interactive menu script that centralises access to all other scripts. Takes no arguments.

**Menu options:**

```
MENU:
1: Register material
2: Register sale
3: Maintenance
4: Statistics
0: Exit
```

**Behaviour:**

| Option | Action                                                                                                                 |
| ------ | ---------------------------------------------------------------------------------------------------------------------- |
| **1**  | Prompts user for material name, price, and optional daily limit; calls `regista_material.sh`.                          |
| **2**  | Prompts user for seller name, material, and weight; calls `regista_venda.sh`.                                          |
| **3**  | Directly calls `manutencao.sh`.                                                                                        |
| **4**  | Prompts user to select statistics (1–5); if option 5 is selected, calls `stats.sh` without arguments to run all stats. |
| **0**  | Exits the menu.                                                                                                        |

> The menu loops iteratively (not recursively) until option 0 is chosen. No input validation is performed here — all validation is delegated to the respective sub-scripts.

---

## Output Macros

All scripts must use the provided macros from `so_utils.sh` (never `echo`) for result reporting:

| Macro                              | Usage                                                                                                                            |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `so_success <step> [info...]`      | Reports successful completion of a step.                                                                                         |
| `so_error <step> [description...]` | Reports an error at a step. Usually causes the script to terminate immediately unless explicitly marked as "does NOT terminate". |
| `so_debug [message...]`            | Debug output, suppressed when `SO_HIDE_DEBUG=1` is exported.                                                                     |

To suppress debug output, uncomment in the script:

```bash
# export SO_HIDE_DEBUG=1
```

---

## File Structure

```
trab-2025-parte-1/
├── regista_material.sh     # S1 — Material registration
├── regista_venda.sh        # S2 — Sale registration
├── manutencao.sh           # S3 — Daily maintenance
├── stats.sh                # S4 — Statistics report
├── menu.sh                 # S5 — Interactive menu
├── cron.def                # Cron job configuration
├── so_utils.sh             # Provided utility macros
├── materiais.txt           # Materials database (auto-generated)
├── vendas.txt              # Sales database (auto-generated)
├── materiais-ordenados-preco.txt  # Sorted materials (auto-generated)
├── stats.html              # HTML statistics report (auto-generated)
└── validator/
    └── so_2025_trab1_validator    # Automated validation script
```

---
