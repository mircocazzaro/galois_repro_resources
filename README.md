# [EA&B] Galois Revisited: How Reliable Is SQL-over-LLM Execution?

This repository contains the code, benchmark data, evaluation script, and supplementary results for the paper **“[EA&B] Galois Revisited: How Reliable Is SQL-over-LLM Execution?”**

The study revisits **Galois**, a system for executing SQL queries over Large Language Models (LLMs), from a reproducibility perspective. The repository provides an independent Python reproduction, **`py-galois`**, together with the benchmark resources needed to inspect, run, and evaluate SQL-over-LLM experiments.

The repository includes the reproduced system, the benchmark data, the evaluation utilities, and additional results that could not be included in the camera-ready version of the paper for space reasons. In particular, it contains the **Paintings Extended** benchmark used in the main paper, the **Nobel Prizes** benchmark used as an additional reproducibility benchmark, and the full **$\tau$-tuning** analysis for the confidence-guided Galois configuration.

Overall, the material confirms the main findings of the paper. Direct prompting baselines remain very strong; Galois-style structured execution is not uniformly superior; optimized Galois variants are useful only in localized query families; and cost must be considered together with quality. The $\tau$-tuning experiment further suggests that, for the considered LLM backend, changing the confidence threshold does not substantially alter performance.

---

## Repository contents

```text
.
├── benchmarks/
│   ├── paintings_extended/
│   │   ├── artist.csv
│   │   ├── canvas_size.csv
│   │   ├── image_link.csv
│   │   ├── museum.csv
│   │   ├── paintings.json
│   │   ├── product_size.csv
│   │   ├── queries_paintings.sql
│   │   ├── queries_paintings.txt
│   │   ├── subject.csv
│   │   └── work.csv
│   │
│   └── nobel_prizes/
│       ├── ingest_nobel_prizes.sql
│       ├── nobel_prizes.json
│       ├── nobel_prizes_1901_2023_awardees.csv
│       ├── nobel_prizes_1901_2023_recipients.csv
│       ├── queries_nobel_prizes.sql
│       └── queries_nobel_prizes.txt
│
├── pygalois/
│   └── py_galois/
│       ├── calibrate_tau.py
│       ├── dataio.py
│       ├── evaluator.py
│       ├── expected_sql.py
│       ├── json_utils.py
│       ├── llm_client.py
│       ├── logic.py
│       ├── metrics.py
│       ├── prompts.py
│       ├── runner.py
│       ├── scan.py
│       └── sql_utils.py
│
├── scripts/
│   ├── audit_alias_predicate_binding.py
│   └── audit_multitable_joins.py
│
├── figures/
│   ├── delta_distribution_grid_vs_nl_nobel_prizes.png
│   ├── efficiency_tokens_time_scatter_nobel_prizes.png
│   ├── query_family_mean_heatmap_grid_nobel_prizes.png
│   ├── success_threshold_curve_all_models_nobel_prizes.png
│   └── tau_avg_score_curve_geo_GPT-4o-mini_galois_f.png
│
├── tables/
│   ├── avg_barplot_table_nobel_prizes.tex
│   ├── quality_profile_table_nobel_prizes_gpt4omini.tex
│   └── quality_profile_table_nobel_prizes_llama38b.tex
│
├── results/
│   └── nobel_prizes/
│       ├── per_query_results.csv
│       ├── query_means_across_runs.csv
│       ├── query_mean_summary.csv
│       ├── method_summary_by_runs.csv
│       └── run_metrics.csv
│
├── SOURCE_HASHES.md
└── galois_eval.py
```

The `benchmarks/` directory contains the benchmark schemas, source tables, SQL queries, and natural-language questions. The `pygalois/` directory contains the Python reproduction of the Galois execution model. The `scripts/` directory contains the audit utilities described below. The `figures/` and `tables/` directories contain the additional plots and LaTeX tables discussed below, and `results/` contains the per-query and per-family measurements behind them. `SOURCE_HASHES.md` records the SHA-256 of every source file, so that a reported number can be tied to the exact code that produced it. The `galois_eval.py` script evaluates predicted result sets against ground-truth answers using the metrics adopted in the paper.

---

## Relation to the paper

The paper studies Galois along three axes.

First, it studies **reproducibility** by re-running the original Galois artifact under a current model. Second, it studies **replicability** through `py-galois`, an independent Python reimplementation of the Galois execution model. Third, it studies **generalization** through parametric benchmarks, repeated runs, multiple LLM backends, and DSPy-based prompt optimization.

The main paper focuses primarily on the **Paintings Extended** benchmark. This repository also includes the **Nobel Prizes** benchmark and the full **$\tau$-tuning** analysis as additional supporting material. These additional results reinforce the same conclusions reported in the paper: direct prompting remains a strong baseline, Galois-style structured execution is query-family-dependent, and prompt and implementation details materially affect SQL-over-LLM execution.

---

## Benchmarks

### Paintings Extended

`benchmarks/paintings_extended/` contains a cultural-heritage benchmark built around museums, artists, works, subjects, images, canvas sizes, and product sizes.

It includes CSV source tables, a JSON schema description, SQL queries, and corresponding natural-language questions. The benchmark is organized into query families. Each family preserves the same SQL structure while varying predicate values, making it possible to study whether SQL-over-LLM execution is stable across semantically related variants.

This is the main benchmark used in the reproducibility experiments reported in the paper.

### Nobel Prizes

`benchmarks/nobel_prizes/` contains a second parametric benchmark built from Nobel Prize data.

It includes source tables for awardees and recipients, a JSON schema description, SQL queries, natural-language questions, and an ingestion script. This benchmark follows the same methodological motivation as Paintings Extended: rather than evaluating a single query per information need, it groups related queries into families and instantiates each family through multiple predicate values. This makes it possible to distinguish aggregate performance from query-family-level behavior.

The Nobel Prizes benchmark is used as an additional reproducibility benchmark and is discussed in detail in the supplementary-results section of this README.

---

## Execution modes

The system supports the six execution modes considered in the paper.

| Mode        | Meaning                                           |
| ----------- | ------------------------------------------------- |
| `nl`        | Direct natural-language prompting baseline.       |
| `sql`       | Direct SQL prompting baseline.                    |
| `galois_wo` | Unoptimized structured Galois-style execution.    |
| `galois_s`  | Selectivity-inspired Galois-style optimization.   |
| `galois_a`  | All-pushdown Galois-style optimization.           |
| `galois_f`  | Full confidence-guided Galois-style optimization. |

The Galois modes separate LLM-facing tuple acquisition from deterministic relational processing. The model is used to retrieve candidate tuples, while relational operations that can be computed locally are executed offline.

---

## Installation

Create a Python environment and install the required packages.

```bash
python -m venv .venv
source .venv/bin/activate

pip install openai pandas duckdb requests rapidfuzz python-Levenshtein orjson
```

For IBM watsonx.ai support, also install:

```bash
pip install ibm-watsonx-ai
```

Since the repository currently exposes `py-galois` as a local source directory, add it to `PYTHONPATH` before running the modules:

```bash
export PYTHONPATH="$PWD/pygalois:$PYTHONPATH"
```

On Windows PowerShell:

```powershell
$env:PYTHONPATH="$PWD\pygalois;$env:PYTHONPATH"
```

---

## LLM backends

The runner supports several providers through `py_galois.llm_client`.

Common options are:

```text
openai:<model>
azure
azure-foundry-openai
ollama:<model>
openrouter
watsonx:<model_id>
grok
```

No credential is stored in this repository: every key constant in `pygalois/py_galois/llm_client.py` is empty, and the Azure path reads its configuration from the environment, falling back to those constants only if the variables are unset. Supply your own credentials through the environment rather than editing the source.

For OpenAI models, set:

```bash
export OPENAI_API_KEY="..."
```

For an Azure OpenAI deployment, set:

```bash
export AZURE_OPENAI_API_KEY="..."
export AZURE_OPENAI_BASE_URL="https://<resource>.openai.azure.com/openai/v1/"
export AZURE_OPENAI_DEPLOYMENT="<deployment-name>"
```

The deployment can also be given inline as `--provider azure:<deployment-name>`, which takes precedence over the environment variable.

For local Ollama models, make sure Ollama is running and that the model is available:

```bash
ollama serve
ollama pull llama3.3:8b
```

Then use, for example:

```bash
--provider ollama:llama3.3:8b
```

Azure, Azure Foundry, OpenRouter, Grok, and watsonx.ai settings are configured in `pygalois/py_galois/llm_client.py`. Before running public experiments, replace local or private endpoint values with your own credentials and deployments.

---

## Running `py-galois`

The main runner is `py_galois.runner`.

A minimal run on Paintings Extended with direct SQL prompting is:

```bash
PYTHONPATH=pygalois python -m py_galois.runner \
  --data-root benchmarks \
  --datasets paintings_extended \
  --provider openai:gpt-4o-mini \
  --mode sql \
  --tau 0.6 \
  --out runs/sql_gpt4omini
```

A Galois full-optimizer run is:

```bash
PYTHONPATH=pygalois python -m py_galois.runner \
  --data-root benchmarks \
  --datasets paintings_extended \
  --provider openai:gpt-4o-mini \
  --mode galois_f \
  --tau 0.6 \
  --out runs/galoisf_gpt4omini
```

To run all modes on Paintings Extended:

```bash
for mode in nl sql galois_wo galois_s galois_a galois_f
do
  PYTHONPATH=pygalois python -m py_galois.runner \
    --data-root benchmarks \
    --datasets paintings_extended \
    --provider openai:gpt-4o-mini \
    --mode "$mode" \
    --tau 0.6 \
    --out "runs/${mode}_gpt4omini"
done
```

To run the Nobel Prizes benchmark, replace the dataset name:

```bash
PYTHONPATH=pygalois python -m py_galois.runner \
  --data-root benchmarks \
  --datasets nobel_prizes \
  --provider openai:gpt-4o-mini \
  --mode sql \
  --tau 0.6 \
  --out runs/sql_gpt4omini_nobel
```

To re-execute only part of a dataset, pass a comma-separated list of 1-based query indices. Every other query is skipped and its existing output is left untouched, which is useful when a fix affects only some queries and the rest should not be paid for again:

```bash
PYTHONPATH=pygalois python -m py_galois.runner \
  --data-root benchmarks \
  --datasets paintings_extended \
  --provider openai:gpt-4o-mini \
  --mode galois_a \
  --tau 0.6 \
  --only-queries 9,10,13,14 \
  --out runs/galoisa_gpt4omini
```

Each run writes one output file and one log file per query:

```text
runs/<run_name>/<dataset>/query1.json
runs/<run_name>/<dataset>/query1.log
runs/<run_name>/<dataset>/query2.json
runs/<run_name>/<dataset>/query2.log
...
```

Each JSON output has the following structure:

```json
{
  "result_set": [
    {
      "column_name": "value"
    }
  ],
  "time": 1.23,
  "tokens": 456
}
```

The log files contain the executed SQL query, selected plan information, scan-level details, token usage, and execution time.

---

## Evaluating results

The evaluation script is:

```text
galois_eval.py
```

It computes the same family of metrics used in the paper.

| Metric             | Meaning                                                              |
| ------------------ | -------------------------------------------------------------------- |
| `F1-Cell`          | Cell-level F1 between predicted and expected values.                 |
| `Cardinality`      | Agreement between predicted and expected tuple counts.               |
| `Tuple Constraint` | Fraction of expected tuples reproduced in full.                      |
| `AVG-Score`        | Arithmetic mean of `F1-Cell`, `Cardinality`, and `Tuple Constraint`. |

The script expects two directory trees:

```text
ground/
└── paintings_extended/
    ├── query1.json
    ├── query2.json
    └── ...

runs/
└── sql_gpt4omini/
    └── paintings_extended/
        ├── query1.json
        ├── query2.json
        └── ...
```

A typical evaluation command is:

```bash
python galois_eval.py \
  --ground ground \
  --submissions runs/sql_gpt4omini \
  --datasets paintings_extended \
  --cell-metric similarity \
  --tuple-metric constraint \
  --format table \
  --jobs 4 \
  --jobs-queries 8
```

To obtain a single aggregate row:

```bash
python galois_eval.py \
  --ground ground \
  --submissions runs/sql_gpt4omini \
  --datasets paintings_extended \
  --cell-metric similarity \
  --tuple-metric constraint \
  --format table \
  --overall
```

To export LaTeX output:

```bash
python galois_eval.py \
  --ground ground \
  --submissions runs/sql_gpt4omini \
  --datasets paintings_extended \
  --cell-metric similarity \
  --tuple-metric constraint \
  --format tex \
  --latex-booktabs \
  --latex-caption "Evaluation results on Paintings Extended" \
  --latex-label "tab:paintings-results"
```

The benchmark directories contain the source data and SQL queries needed to compute expected answers. The evaluator itself compares materialized expected outputs against materialized system outputs; it does not call the LLM.

---

## Tau calibration utility

The full Galois configuration, `galois_f`, uses a confidence threshold `tau` for physical scan selection.

The repository includes a helper script for sweeping `tau` values:

```bash
PYTHONPATH=pygalois python -m py_galois.calibrate_tau \
  --data-root benchmarks \
  --provider openai:gpt-4o-mini \
  --dataset paintings_extended \
  --taus 0.0,0.2,0.4,0.6,0.8,1.0 \
  --out tau_sweep
```

The paper keeps `tau = 0.6`, following the original Galois setup. The supplementary `tau` analysis reported below shows that changing this threshold does not materially alter the main conclusions for the tested backend and dataset.

---

## Audit scripts

The `scripts/` directory contains the two audit utilities referenced in the paper. Both are read-only and neither calls an LLM.

### Predicate-to-relation binding

```bash
python scripts/audit_alias_predicate_binding.py
```

This script checks that every `WHERE` atom of every benchmark query is bound to the relation it belongs to, including when the query uses a table alias, with or without the optional `AS` keyword, and when a quoted literal contains a dot. It reports, per dataset, how many atoms were extracted, how many were bound, and how many were lost. On the benchmarks in this repository it reports zero lost predicates out of 330, which is the check behind the predicate-binding correction described in the paper.

### Multi-table join execution

```bash
python scripts/audit_multitable_joins.py \
  --run-dir runs/galoisa_gpt4omini/paintings_extended \
  --family-size 10
```

This script reads the per-query logs of an existing run and reconstructs, operator by operator, what each scan returned and what the join then produced. It reports how many join conditions found no matching key value on either side, how many had non-empty scans whose keys did not intersect, and where in the plan the result became empty. It is the script behind the operator-level join evidence reported in the paper, and it requires a run directory produced beforehand by `py_galois.runner`.

---

# Supplementary results

This section reports additional results that complement the main paper. The focus is twofold. First, we report the reproducibility analysis on the **Nobel Prizes** benchmark, a second parametric benchmark designed with the same rationale as Paintings Extended. Second, we report an additional **$\tau$-tuning** analysis for the full Galois configuration.

The Nobel Prizes results are reported for **GPT-4o-mini** and **Llama 3 8B**. Quality is measured with the same metrics used in the paper: `F1-Cell`, `Cardinality`, `Tuple Constraint`, and their arithmetic mean, `AVG-Score`.

---

## Aggregate results on Nobel Prizes

The aggregate AVG-Score table is available in:

```text
tables/avg_barplot_table_nobel_prizes.tex
```

| Method     |   GPT-4o-mini |    Llama 3 8B |
| ---------- | ------------: | ------------: |
| `NL`       | 0.681 (0.005) | 0.509 (0.344) |
| `SQL`      | 0.649 (0.007) | 0.656 (0.000) |
| `GaloisWO` | 0.085 (0.032) | 0.178 (0.000) |
| `GaloisS`  | 0.263 (0.017) | 0.217 (0.012) |
| `GaloisA`  | 0.375 (0.014) | 0.308 (0.019) |
| `GaloisF`  | 0.273 (0.019) | 0.215 (0.012) |

The aggregate picture is consistent with the conclusions of the paper. On GPT-4o-mini, `NL` and `SQL` are clearly stronger than the Galois variants, with `NL` reaching the best average score. On Llama 3 8B, `SQL` is the strongest method, while `NL` shows high variability. The structured Galois variants improve over `GaloisWO`, but they remain below the direct prompting baselines in aggregate quality.

Among the structured modes, `GaloisA` is the strongest on both models, ahead of `GaloisF` and `GaloisS`, which stay close to each other. The three are therefore not interchangeable on this benchmark, and the all-pushdown policy is what accounts for most of the improvement over the unoptimized structured baseline.

This supports the same interpretation developed in the paper: Galois-style execution should not be understood as uniformly better than direct prompting. Its value is conditional on the query family, the model backend, and the quality/cost regime.

---

## Delta distributions against NL

![Per-query AVG-Score delta distributions against NL](figures/delta_distribution_grid_vs_nl_nobel_prizes.png)

This plot reports, for each model, the per-query difference in AVG-Score between each method and the `NL` baseline. The dashed horizontal line marks parity with `NL`. Points above zero indicate queries where a method outperforms direct natural-language prompting; points below zero indicate queries where it underperforms.

For GPT-4o-mini, `SQL` is close to `NL` on average but does not systematically dominate it. The Galois variants mostly lie below the `NL` baseline, indicating that structured execution tends to lose quality on this benchmark. For Llama 3 8B, `SQL` often improves over `NL`, while the Galois variants again tend to remain below the direct baseline.

The important observation is not only the average gap, but also the spread. Some queries benefit from alternative prompting or structured execution, while many others do not. This confirms that SQL-over-LLM behavior is query-dependent and that aggregate metrics can hide substantial per-query variability.

---

## Quality/cost trade-offs

![Quality/cost trade-offs](figures/efficiency_tokens_time_scatter_nobel_prizes.png)

This figure relates AVG-Score to execution cost, measured both in total token usage and total execution time. The best methods are those that appear toward the upper-left area of the plots: high quality with low token or time cost.

The Nobel Prizes results reinforce the cost-related conclusions of the paper. Direct `NL` and `SQL` prompting reach the highest quality scores while using substantially fewer tokens and less time than the structured Galois variants. The Galois methods, especially `GaloisWO`, can be much more expensive while producing lower aggregate quality.

This matters because the usefulness of SQL-over-LLM execution cannot be evaluated by quality alone. A structured plan may be attractive from a database-system perspective, but if it requires many additional LLM calls and does not improve result quality, the resulting quality/cost trade-off becomes unfavorable.

---

## Query-family behavior

![Mean AVG-Score by query family](figures/query_family_mean_heatmap_grid_nobel_prizes.png)

The heatmap reports mean AVG-Score by query family, model, and method. This is the most informative plot for understanding where structured execution helps and where it fails.

The dominant pattern is the collapse on `q2` and `q4`, the two families that require a join between awardees and recipients. There every structured mode falls to near zero, at most 0.060 on GPT-4o-mini and at most 0.032 on Llama 3 8B, while the direct baselines stay between 0.46 and 0.85. This is the multi-relation effect analysed in the paper: the two sides of the join are materialised by separate model calls, so their key values need not agree.

Outside those two families structured execution is competitive. On `q1` it is close to parity, with `GaloisA` at 0.963 against 1.000 for `NL` on GPT-4o-mini and at 0.900 against 1.000 for `SQL` on Llama 3 8B. On `q3` with Llama 3 8B it is the only family of the benchmark that structured execution wins outright, `GaloisA` reaching 0.350 against 0.333 for the better direct baseline, although all methods score low there.

Family `q5`, the one combining `COUNT` with `GROUP BY` over a range, is where the two pushdown policies part ways, and in opposite directions on the two models. On GPT-4o-mini `GaloisA` is the best structured mode at 0.518 while `GaloisS` and `GaloisF` fall to about 0.05; on Llama 3 8B the ordering inverts, with `GaloisWO`, `GaloisS` and `GaloisF` between 0.558 and 0.584, close to the direct baselines, and `GaloisA` down at 0.236. Which pushdown policy pays off on an aggregation family is therefore backend-dependent, which is the same implementation and prompt sensitivity that the paper reports.

This supports one of the central claims of the paper: the value of structured execution is query-semantics-dependent rather than uniform. Galois-style decomposition is not generally superior, but it can still be useful for specific query families where the interaction between predicates, tuple retrieval, and post-processing is favorable.

---

## Success-threshold curves

![Query success curves by model](figures/success_threshold_curve_all_models_nobel_prizes.png)

The success-threshold curves show the fraction of queries whose AVG-Score is at or above a given threshold. They provide a robustness-oriented view of the results: a method is stronger if its curve remains high as the threshold increases.

On GPT-4o-mini, `NL` and `SQL` preserve a much larger fraction of successful queries across medium and high thresholds. The Galois curves drop earlier, meaning that structured execution produces fewer high-quality query results. On Llama 3 8B, `SQL` is the most robust method, while `NL` is competitive at lower thresholds but less stable overall. The Galois variants remain mostly concentrated in low-to-medium score regions.

These curves make explicit what the aggregate table already suggests: on the Nobel Prizes benchmark, direct prompting is not only better on average, but also more robust across quality thresholds.

---

## Quality profiles

The following table reports the merged quality profile for the Nobel Prizes benchmark across the two evaluated models and all execution methods. For each model--method pair, we report `F1-Cell`, `Cardinality`, `Tuple Constraint`, and `AVG-Score` as mean and standard deviation.

| Model       | Method     |       F1-Cell |   Cardinality | Tuple Constraint |     AVG-Score |
| ----------- | ---------- | ------------: | ------------: | ---------------: | ------------: |
| GPT-4o-mini | `NL`       | 0.732 (0.007) | 0.940 (0.003) |    0.371 (0.010) | 0.681 (0.005) |
| GPT-4o-mini | `SQL`      | 0.729 (0.006) | 0.827 (0.006) |    0.391 (0.015) | 0.649 (0.007) |
| GPT-4o-mini | `GaloisWO` | 0.094 (0.036) | 0.137 (0.055) |    0.025 (0.016) | 0.085 (0.032) |
| GPT-4o-mini | `GaloisS`  | 0.214 (0.020) | 0.372 (0.017) |    0.201 (0.018) | 0.263 (0.017) |
| GPT-4o-mini | `GaloisA`  | 0.355 (0.016) | 0.559 (0.017) |    0.211 (0.013) | 0.375 (0.014) |
| GPT-4o-mini | `GaloisF`  | 0.225 (0.023) | 0.388 (0.021) |    0.206 (0.018) | 0.273 (0.019) |
| Llama 3 8B  | `NL`       | 0.548 (0.372) | 0.630 (0.408) |    0.349 (0.252) | 0.509 (0.344) |
| Llama 3 8B  | `SQL`      | 0.727 (0.000) | 0.808 (0.000) |    0.432 (0.000) | 0.656 (0.000) |
| Llama 3 8B  | `GaloisWO` | 0.152 (0.000) | 0.378 (0.000) |    0.004 (0.000) | 0.178 (0.000) |
| Llama 3 8B  | `GaloisS`  | 0.187 (0.013) | 0.416 (0.011) |    0.047 (0.011) | 0.217 (0.012) |
| Llama 3 8B  | `GaloisA`  | 0.276 (0.026) | 0.452 (0.025) |    0.196 (0.012) | 0.308 (0.019) |
| Llama 3 8B  | `GaloisF`  | 0.185 (0.013) | 0.413 (0.011) |    0.047 (0.011) | 0.215 (0.012) |

For GPT-4o-mini, the direct baselines obtain much higher `F1-Cell` and `Cardinality` than the Galois variants. `NL` reaches the best aggregate score mainly because it combines strong cell-level correctness with very high cardinality. `SQL` is close in `F1-Cell` and slightly stronger in `Tuple Constraint`, but lower in cardinality.

For Llama 3 8B, `SQL` is the strongest method across the aggregate score and gives a more stable profile than `NL`, whose standard deviation is large. The Galois variants have lower tuple-level correctness and remain far from the direct baselines, although the optimized variants improve over the unoptimized `GaloisWO` baseline in some dimensions.

The profiles also show where `GaloisA` gains over the other two structured modes. On GPT-4o-mini its advantage is concentrated in `Cardinality`, 0.559 against 0.372 and 0.388, while `Tuple Constraint` is almost the same across the three; the same holds on Llama 3 8B, where `Cardinality` is 0.452 against roughly 0.41 but `Tuple Constraint` reaches 0.196 against 0.047. Pushing every predicate into the scan therefore mainly helps the model return the right number of rows, and only on the weaker model does it also help reconstruct whole tuples.

The quality profiles therefore clarify why the aggregate results look the way they do. The main weakness of the Galois variants is not only final `AVG-Score`, but also the combination of incomplete tuple retrieval, weaker cell-level recall, and lower tuple reconstruction quality.

---

## Tau tuning

![Tau tuning for GaloisF](figures/tau_avg_score_curve_geo_GPT-4o-mini_galois_f.png)

The $\tau$ parameter controls the confidence threshold used by the full Galois configuration (`GaloisF`) when selecting the physical scan strategy. Since this threshold can in principle affect the balance between `TableScan` and `KeyScan`, we evaluated whether tuning $\tau$ materially changes performance.

The tuning experiment was conducted on one of the original datasets, **Geo**, using **GPT-4o-mini** as the LLM backend and `GaloisF` as the execution mode. The tested values cover the full range from $\tau = 0.0$ to $\tau = 1.0$.

The curve shows that performance is largely stable across thresholds. The best observed value is $\tau = 0.2`, with an AVG-Score of approximately 0.496, but the differences across thresholds are small and the confidence intervals largely overlap. In practice, changing $\tau$ does not substantially alter the behavior of the system on the considered backend.

This result suggests that, at least for this model and dataset, the confidence threshold is not the main factor explaining the observed performance. The dominant sources of variation appear to be the LLM backend, prompt formulation, query semantics, tuple retrieval behavior, and parsing/post-processing pipeline. For this reason, the paper keeps $\tau$ fixed in the main experiments and treats prompt structure and query-family behavior as more relevant axes of analysis.

---

## How these additional results support the paper

The Nobel Prizes and $\tau$-tuning results reinforce the main conclusions of the paper.

First, direct prompting is a strong baseline. On Nobel Prizes, `NL` is strongest for GPT-4o-mini, while `SQL` is strongest for Llama 3 8B. This confirms that any SQL-over-LLM execution framework must be compared against carefully designed direct prompting baselines.

Second, Galois-style structured execution is not uniformly superior. The optimized variants improve over the unoptimized structured baseline, but they do not close the gap with direct prompting in aggregate quality.

Third, structured execution is query-family-dependent. The heatmaps show that Galois variants can be competitive in specific families, but they also fail almost completely in others. This supports a more nuanced interpretation: Galois is not a universal replacement for direct prompting, but a structured execution strategy whose usefulness depends on the query semantics.

Fourth, cost is central. The quality/cost scatter plot shows that structured execution may require substantially more tokens and time. When this additional cost is not matched by a quality improvement, the trade-off becomes unfavorable.

Finally, $\tau$ tuning does not change the overall picture. Although the best observed threshold in the Geo experiment is $\tau = 0.2`, the performance curve is nearly flat. This suggests that, for the considered backend, varying the confidence threshold is substantially less important than understanding prompt sensitivity, backend behavior, and query-family effects.

---

## Reproducibility notes

The experiments involve LLM backends, so exact numerical results may depend on model version, provider, deployment configuration, decoding parameters, rate limits, and output formatting behavior.

For the most controlled setting, use fixed model deployments, temperature `0`, fixed `top_p` when supported, fixed `tau`, the same prompts and parsing utilities, the same benchmark data and query files, and repeated runs when the backend is not fully deterministic.

The paper reports that locally served open-weight models can produce zero standard deviation across repeated runs under deterministic decoding, while hosted models may still exhibit small run-to-run variation.

---

## Revision notes

This revision of the repository updates the code and the Nobel Prizes results. Two corrections to `py-galois` were made while auditing the implementation, and every affected number was recomputed from re-executed runs.

The first correction concerns the `galois_a` mode. It was previously planned through the same confidence-based path as `galois_f`, so predicate classification could drop predicates before the surviving ones were relabelled as all-pushdown, and the physical operator was still chosen by comparing an elicited confidence against `tau`. It is now planned by a dedicated function that pushes every predicate assigned to a relation, fixes the physical operator to `TableScan`, and never issues a confidence prompt, which is the policy the mode is meant to implement. See `build_all_pushdown_table_plan` in `pygalois/py_galois/logic.py` and its use in `pygalois/py_galois/runner.py`.

The second correction concerns predicate-to-relation binding in `extract_where_atoms`. A table alias could be misread when it was not introduced by `AS`, when the token following the relation was a keyword such as `WHERE`, or when a quoted literal contained a dot, as in `'Barack H. Obama'`. A predicate could then be attributed to the wrong relation or omitted. See `pygalois/py_galois/sql_utils.py`, and `scripts/audit_alias_predicate_binding.py` for the check that verifies the fix.

Both corrections affect only the structured modes that push predicates into the scans. The direct baselines and `galois_wo`, which pushes none, are unchanged, which is visible in the tables above: `NL`, `SQL` and `GaloisWO` report the same values as before, while `GaloisS`, `GaloisA` and `GaloisF` improve. On the Nobel Prizes benchmark `GaloisA` moves from 0.211 to 0.375 on GPT-4o-mini and from 0.202 to 0.308 on Llama 3 8B. The conclusions of the paper are unaffected: the structured modes remain below the direct baselines in aggregate quality, and their advantage remains confined to specific query families.

Also in this revision: the LLM client no longer requires `ibm-watsonx-ai` to be installed unless the watsonx backend is used, the Azure configuration is read from the environment, the runner accepts `--only-queries` for targeted re-execution, per-query and per-family Nobel results are included under `results/`, compiled bytecode is no longer tracked, and `SOURCE_HASHES.md` records the SHA-256 of every source file.

---

## Main takeaways

The repository supports the following conclusions from the paper.

First, the Galois execution architecture is structurally reproducible: the separation between LLM-facing scans and deterministic relational processing can be independently rebuilt.

Second, optimized Galois configurations are implementation-sensitive. Prompt wording, JSON repair, predicate extraction, confidence parsing, and physical scan selection can change the tuples retrieved by the model.

Third, direct natural-language and SQL prompting are strong baselines. On the evaluated benchmarks, they often outperform Galois variants in aggregate quality and cost.

Fourth, Galois-style structured execution remains useful in specific query families. Its value is query-semantics-dependent rather than uniform.

Finally, prompt structure is itself an optimization dimension for SQL-over-LLM systems. Improving prompts can affect both direct baselines and Galois-style scan operators without changing the underlying execution plan.




