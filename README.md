# [EA&B] Galois Revisited: How Reliable Is SQL-over-LLM Execution?

> **Research use only. Not a medical device.**
> This software was developed in the HEREDITARY project as a research prototype. It has not been assessed or certified under the EU Medical Device Regulation (EU) 2017/745. It must not be used to diagnose, treat, monitor or make any other decision about individual patients.

## 1. Overview

This repository contains the independent Python reproduction **`py-galois`**, benchmark data, evaluation utilities and supplementary results for **“[EA&B] Galois Revisited: How Reliable Is SQL-over-LLM Execution?”** The study examines the reproducibility, replicability and generalization of SQL execution over the knowledge of large language models (LLMs).

The release includes Paintings Extended, the main benchmark, and Nobel Prizes, an additional parametric benchmark. It also includes supplementary Nobel results and a confidence-threshold (`tau`) analysis reported on Geo. Geo's benchmark files and raw tau-sweep outputs are not included in this checkout.

| Field | Value |
|---|---|
| Name | Galois Revisited reproducibility resources (`py-galois`) |
| Version | Repository snapshot `00e84bdbb7e391463a2590c898044636732787b1`; no release tag is present in the inspected checkout |
| Type | Research software, benchmark datasets, evaluation utilities and supplementary results; no trained model weights are distributed |
| Owner partner and contact | HEREDITARY research context: University of Padua (UNIPD). Repository maintainer: Mirco Cazzaro, mirco.cazzaro.1999@gmail.com. No separate ownership declaration is present in the repository. |
| License | No project-level code license or dataset license is declared in the inspected checkout. Public repository access alone does not establish an open-source license or unrestricted rights to redistribute the benchmark data. |
| Repository and DOI | https://github.com/mircocazzaro/galois_repro_resources; no software or paper DOI is documented in the checkout |
| Release date | 27 August 2026, the date of the documented commit; this identifies the snapshot rather than a separately tagged release |
| Related task or deliverable | HEREDITARY research software; this README follows the template requested for D9.1. A development task or deliverable identifier is not specified in the repository. |
| How to cite | Cazzaro, M. (2026). Galois Revisited reproducibility resources [Software and benchmark resources, commit 00e84bdbb7e391463a2590c898044636732787b1]. https://github.com/mircocazzaro/galois_repro_resources. Associated paper: “[EA&B] Galois Revisited: How Reliable Is SQL-over-LLM Execution?” |

## 2. Intended use

**Primary intended use.** Reproduce and inspect SQL-over-LLM experiments; compare direct natural-language and SQL prompting with structured Galois execution; study query-family effects, implementation sensitivity, quality, token consumption and execution time.

**Intended users.** Database and NLP researchers, reproducibility reviewers and developers studying LLM-based query execution.

**Out-of-scope uses.** This release must not be used for:

- clinical diagnosis, prognosis, monitoring or treatment of individual patients;
- decisions about individuals, such as insurance, employment or access to care;
- re-identification of individuals or unauthorized linkage with other data sources;
- inferring undisclosed personal attributes or using generated records as verified information about individuals;
- treating an LLM-generated result set as an authoritative or complete database answer;
- claiming validated performance on populations, domains or backends outside the documented experiments.

Use the supplied public-knowledge benchmarks for reproduction. Do not submit patient data, confidential records or secrets in prompts. Provider credentials and any costs incurred by new experiments are the operator's responsibility.

## 3. Data provenance

| Dataset | Source partner | Type (public, synthetic, pseudonymized, anonymized) | Population (size, age, sex, country, condition) | Ethics approval or access conditions |
|---|---|---|---|---|
| Paintings Extended | Distributed in this repository; original upstream source, collection date and data license are not identified in the checkout | Public-knowledge benchmark tables covering artworks, artists, museums and related entities; not an anonymized clinical dataset | 421 artist rows, 57 museums, 14,776 works, 14,775 image links, 6,771 subject rows, 200 canvas-size rows and 110,347 product-size rows. Artist records include names, nationality and birth/death years; no patient population. | No ethics approval or dataset-specific redistribution license is documented. Public subject matter does not establish the license of the source compilation or linked images. |
| Nobel Prizes, 1901–2023 | Distributed in this repository; original upstream source, collection date and data license are not identified in the checkout | Public-knowledge benchmark with identifiable biographical records; not synthetic or anonymized | 970 awardee rows and 970 recipient rows; these are table-row counts, not a claim of 970 unique individuals. Recipient fields include names, sex, dates and places of birth/death. No patient cohort or clinical condition. | No ethics approval or dataset-specific redistribution license is documented. |
| Nobel experiment measurements | Released CSV files under `results/nobel_prizes/` | Derived query-quality, token and timing measurements for GPT-4o-mini and Llama 3 8B | 50 queries; model/method/run and query-family groupings, not participant subgroups | Published as research results; no separate data license is documented |
| Geo tau analysis | Figure and narrative included in this repository | Derived experimental result; source dataset and raw sweep outputs are not bundled | Not a clinical population; dataset size and record-level provenance cannot be established from the included figure | Complete rerunning requires the corresponding external dataset and evaluation resources |

**Release-content scope.** This repository includes real names and biographical attributes of public figures, including Nobel recipients. It therefore cannot use the template's blanket assertion that released files contain no personal data or identifiers. Publicly known biographies are not the same as anonymized data. No clinical records, patient cohort or pseudonymization-key files were identified in the inspected tracked-file inventory; this is not a forensic certification of the full repository history.

All API-key constants inspected in `pygalois/py_galois/llm_client.py` are empty. Provider endpoint/deployment defaults and a project identifier remain in the code; these are configuration values, not proof of available access. Replace them with operator-controlled settings where required.

During execution, prompts may include SQL or natural-language questions, schema information, predicate literals, previously generated keys and retrieved tuples. Hosted backends receive this content. The software does not implement a general redaction or anonymization stage. Outputs and logs can retain generated names, tuples and queries.

## 4. Method

- **Algorithm or architecture.** Direct `nl` and `sql` baselines ask an LLM for result rows. Structured modes obtain candidate tuples through `TableScan` or `KeyScan`, with mode-specific predicate pushdown and confidence-guided planning, then evaluate relational operations locally through SQLite. Source CSVs support computing expected answers; they are not automatically supplied as full tables to the LLM by the runner.
- **Training setting.** Not applicable to model-weight training: the release invokes external or locally served pretrained LLMs and does not train or fine-tune their weights. The associated study discusses DSPy-based prompt optimization, but this checkout does not include a complete DSPy optimization pipeline or a trained model artifact.
- **Privacy techniques.** No differential privacy, secure aggregation, anonymization or access-registration mechanism is implemented in this command-line artifact. Using a local model can keep prompts local only when the operator actually configures and controls the local service. Hosted-provider authentication is credential handling, not a privacy guarantee.

Six modes are exposed: `nl`, `sql`, `galois_wo`, `galois_s`, `galois_a` and `galois_f`. In the audited code, `galois_a` pushes all assigned predicates and fixes the operator to `TableScan`; it does not use confidence prompts or `tau` for operator selection.

## 5. Performance

- **Evaluation data.** Paintings Extended contains 140 SQL queries and Nobel Prizes 50, organized as 14 and 5 families of 10 variants respectively. Expected answers are computed from source tables and compared with generated result sets. These are public-knowledge query benchmarks, not clinical validation sets.
- **Metrics and results.** The evaluator reports cell-level F1, cardinality agreement, tuple constraint and their arithmetic mean (`AVG-Score`), alongside token usage and execution time. The released Nobel summary reports the following AVG-Score means and standard deviations across runs.

| Method | GPT-4o-mini | Llama 3 8B |
|---|---:|---:|
| `NL` | 0.681 (0.005) | 0.509 (0.344) |
| `SQL` | 0.649 (0.007) | 0.656 (0.000) |
| `GaloisWO` | 0.085 (0.032) | 0.178 (0.000) |
| `GaloisS` | 0.263 (0.017) | 0.217 (0.012) |
| `GaloisA` | 0.375 (0.014) | 0.308 (0.019) |
| `GaloisF` | 0.273 (0.019) | 0.215 (0.012) |

GPT-4o-mini has 10 runs per method. Llama 3 8B has 3 runs for `NL` and 10 for each other method, as recorded in `results/nobel_prizes/method_summary_by_runs.csv`. A displayed standard deviation of 0.000 is rounded and does not establish universal determinism.

- **Results by subgroup.** Query-family and backend analyses are included below and in the released CSVs and figures. These are task groupings, not demographic validation. No fairness or performance assessment by sex, age, nationality or other participant subgroup is documented.
- **Verification for this README.** The read-only predicate-binding audit was executed: 330 atoms were bound and none lost across 190 benchmark queries. All 15 entries in `SOURCE_HASHES.md` matched the checked-out sources. The evaluator's command-line help was checked. No paid LLM experiment, live-provider validation or full numerical reproduction was performed while preparing this README.

## 6. Known limitations and risks

- **Generalizability.** Results are specific to the supplied data, queries, prompts, model deployments and run configurations. They do not establish reliability in biomedical, clinical or other unseen domains. Possible overlap between public benchmark facts and model pretraining data is not controlled by this release.
- **Known biases and confounders.** Public-figure and cultural-heritage coverage is not representative of a general population. Model knowledge, linguistic variants, missing facts and provider behavior can affect retrieval. Unequal run counts, prompt details and parser behavior affect comparisons. No systematic demographic bias assessment is documented.
- **Failure modes.** LLMs can invent, omit or inconsistently spell values. Independently generated join keys may not match, producing empty joins despite nonempty scans. SQL parsing, dialect translation, JSON repair and confidence parsing are implementation-sensitive. Some local SQL failures become empty result sets. Provider content-filter refusals can be recorded as empty results with zero tokens, so outputs and logs must be interpreted together.
- **Privacy risks.** Public names and biographies remain identifiable. Prompts and logs can expose sensitive content if the artifact is repurposed with private data. No membership-inference, model-inversion or privacy-leakage assessment of the external models is documented. Keeping API keys out of source does not protect the content transmitted to providers.
- **Reproducibility limits.** Dependencies are not pinned in a lockfile. The original Java artifact, Geo source data, raw tau-sweep outputs and the complete DSPy workflow are not included. Source hashes identify the bundled Python and audit code; they do not certify datasets, provider model versions or experimental outputs.
- **Tau calibration utility.** `calibrate_tau.py` expects a dataset/tau JSONL evaluation file with an `avg` field, while the current runner writes per-query JSON and log files without producing that evaluation file. The helper therefore does not perform a complete working calibration by itself. Use separate output directories and evaluate each threshold explicitly, as shown below.
- **Backend configuration.** Environment-variable configuration is implemented for OpenAI and the Azure OpenAI path, but several other adapters still read module-level configuration constants. Do not assume all providers accept keys from identically named environment variables.
- **Licensing and provenance.** Code and dataset licenses, and precise upstream dataset citations, are not established by this snapshot. Public availability of this repository does not resolve those omissions.

## 7. Responsible use and reporting

- **Terms of use.** Research use is the intended scope described in Section 2. No project-level code or dataset license is documented; this README does not grant additional permissions over the code, source compilations or linked images. Follow the terms applicable to the configured model service.
- **Operational practice.** Keep credentials out of Git, use operator-controlled endpoints, review prompts before remote execution and retain enough configuration to interpret results. Do not use generated tuples for decisions about individuals or treat benchmark scores as guarantees of factual correctness.
- **Contact for misuse or vulnerability reports.** Mirco Cazzaro: mirco.cazzaro.1999@gmail.com. Report sensitive issues privately and do not include credentials or private records in public issues.
- **Interface notice.** This checkout is a command-line research artifact, not a hosted demo or web application. The template's additional web-interface notice is therefore not applicable to this checkout. Any future web demo should display: “Research prototype of the HEREDITARY project. Not a medical device and not for clinical use. Do not enter personal or patient data.”

## 8. Acknowledgement

Funded by the European Union under grant agreement No 101137074 (HEREDITARY). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Health and Digital Executive Agency (HaDEA). Neither the European Union nor the granting authority can be held responsible for them.