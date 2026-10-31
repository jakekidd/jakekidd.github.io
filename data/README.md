# Chart data: measured AI capability over time

Retrieved 2026-10-19. Five JSON files for two charts: **verifiable domains** (a program grades the result: `metr_horizon.json`, `math_competition.json`, most of `human_baseline_saturation.json`) and **judgment domains** (people grade the result: `preference.json`), plus `events.json` for annotations. Every number was copied from a downloaded file or a primary page; nothing was interpolated or estimated. Where a number came secondhand it is marked **(v)**.

## Shape of every file

```
{
  "series": "name of the main series",
  "unit": "...",
  "description": "...",
  "license": "...",
  "retrieved": "2026-10-19",
  "sources": [ ... ],
  "caveats": [ ... ],
  "points": [ {"date": "YYYY-MM-DD", "value": number, "model": "...", "source": "URL", "note": "...", ...extra fields} ],
  "other_series": [ {"series": "...", "unit": "...", "description": "...", "points": [ ... ]} ]
}
```

`human_baseline_saturation.json` puts its per-benchmark records under `benchmarks` instead of `points` (see below). `events.json` has `value: null` for every event.

Common extra fields on points: `ci_low` / `ci_high` (95% interval where the source gives one), `frontier` (point set a new record), `release_event` (see the rule below), `saturated`, `lower_bound`, `stderr`, `evaluated_at` (when Epoch ran the eval, as opposed to the model release `date`).

**Release-event rule.** `release_event: true` marks a point where the jump coincides with a company releasing or announcing, all at once, a result it had developed out of view (a new training method's first release, an unreleased model's result, a batch dump). The jump then dates the disclosure, not the capability. Flagged: o1 (Sept 12, 2024) in the METR and math series; in `events.json` also o3's ARC announcement, the 2025 IMO results, Claude Mythos Preview, the May 2026 unit-distance disproof, Navier-Stokes, the Oct 6, 2026 math release (also `dump: true`) and Anthropic's Oct 16 seeds result.

---

## 1. `metr_horizon.json` (verifiable)

**What:** METR's 50% task-completion time horizon (minutes of human-expert time) for 26 models by release date, GPT-2 (2019-02-14) to Claude Mythos Preview, early version (2026-04-07), on the current Time Horizon 1.1 suite, with METR's 95% CIs and its own `is_sota` flag as `frontier`. `other_series`: the 80% horizon (26 points) and the original Time Horizon 1.0 suite (33 points, 2019 to Nov 2025).

**Source:** METR's machine-readable files behind metr.org/time-horizons: https://metr.org/assets/benchmark_results_1_1.yaml and https://metr.org/assets/benchmark_results_1_0.yaml. They match the data embedded in https://metr.org/time-horizons/ exactly (checked, 0 differences) and agree with Epoch AI's copy (`metr_time_horizons_external.csv` in https://epoch.ai/data/benchmark_data.zip). Code and raw runs: https://github.com/METR/eval-analysis-public (last commit 2026-03-06).

**Doubling time METR reports:** "around 7 months" over 2019 to early 2025 (https://metr.org/blog/2025-03-19-measuring-ai-ability-to-complete-long-tasks/, arXiv 2503.14499). Current TH1.1 YAML: 128.7 days (95% CI 104 to 158), about 4.2 months, for 2023 on; 187.8 days (about 6.2 months) all-time, stitching TH1.0 values for pre-2023 models; the fit "excludes points with central estimate p50 > 16 hrs". TH1.0: 201.2 days all-time, 175.6 days from 2023. METR's Jan 29, 2026 TH1.1 post also gave 88.6 days since 2024 (before its Mar 3, 2026 regularization fix; not in the YAML).

**License:** no explicit license. The repo README says "See LICENSE file for details" but there is no LICENSE file. These are published measurements, cited to METR; Epoch republishes them under CC BY 4.0.

**Caveats:**
- Every METR task is scored automatically: self-contained software, ML and cyber tasks "with clear success criteria that can be automatically evaluated." METR found performance drops when work is scored holistically (https://metr.org/blog/2025-08-12-research-update-towards-reconciling-slowdown-with-time-horizons/).
- The top end is a lower bound. METR: "Measurements above 16 hrs are unreliable with our current task suite." Mythos Preview (17.4 h, CI 8.5 to 55 h) is labeled "likely at least 16 hrs" (`lower_bound: true`). Only 31 of 228 tasks take 8 h or more, and 5 of those have measured human times.
- METR stopped: "This page is no longer actively updated" (last update Sept 8, 2026). Nothing released after April 2026 has a METR number, and METR never claimed full coverage.
- The last point is an early version of a model Anthropic did not release generally (anthropic.com/glasswing).
- TH1.0 and TH1.1 differ for the same model (GPT-5: 131 vs 203 min). Draw them as separate lines.
- METR fits an exponential and calls a logistic fit poor so far ("we haven't seen any evidence of the exponential growth in time horizon slowing down"). Any logistic you draw is your model, not METR's.

## 2. `math_competition.json` (verifiable)

**What:** competition-math frontier by model release date, one line per `benchmark` field (do not join them):
- MATH, full 5,000-problem test set, paper-reported: Hendrycks et al. (2021-03-05, best 6.9%, GPT-2 1.5B, Table 2, https://arxiv.org/abs/2103.03874) and Minerva 540B with majority voting (2022-06-29, 50.3%, https://arxiv.org/abs/2206.14858). 2 points.
- MATH Level 5 (the 1,324 hardest test problems), Epoch AI's own runs, 2023-06 to 2025-08: 22.97% to 98.13%. 12 points.
- OTIS Mock AIME 2024-2025 (45 problems from Evan Chen's three mock exams), Epoch AI's runs, 2023-03 to 2026-04: 0.56% to 100%. 21 points.
- `other_series`: FrontierMath Tiers 1-3 v2 (private, 13 points, to 93.68%), FrontierMath Tier 4 v2 (private, 9 points, 100% on 2026-09-29), FrontierMath-Erdos (68 open Erdos conjectures, Lean-checked, 7 results, best 2.94%), and superseded FrontierMath v1 (12 points).

**Source files (exact):** https://epoch.ai/data/benchmark_data.zip, downloaded 2026-10-19 (CSV `math_level_5.csv`, `otis_mock_aime_2024_2025.csv`, `frontiermath_tiers_1_3_v2.csv`, `frontiermath_tier_4_v2.csv`, `frontiermath.csv`, `frontiermath_erdos.csv`; score column "Best score (across scorers)", as Epoch's `benchmark_metadata.csv` specifies). Benchmark pages: https://epoch.ai/benchmarks/math-level-5, https://epoch.ai/benchmarks/otis-mock-aime-2024-2025, https://epoch.ai/benchmarks/frontiermath, https://epoch.ai/benchmarks/frontiermath-erdos. Exam dates: https://web.evanchen.cc/exams/OTIS-Mock-AIME-2024.pdf (Dec 22, 2023), https://web.evanchen.cc/exams/OTIS-Mock-AIME-2025-I.pdf and -II (Dec 20, 2024).

**License:** Epoch AI data CC BY 4.0 (credit: Epoch AI, "Capabilities & benchmarking", https://epoch.ai/benchmarks).

**Saturation and contamination:**
- MATH Level 5 is saturated (94.7% with o1, Dec 2024; 98.1% with GPT-5). MATH and its solutions have been public since March 2021, so every later model may have seen them. Epoch's page doesn't discuss contamination.
- OTIS Mock AIME is saturated (100%, Apr 2026). It is clean only for models released before Dec 22, 2023 (all 45 problems unseen) or before Dec 20, 2024 (30 unseen); each point's note says which.
- FrontierMath is private (12 of 338 problems public), but it was funded by OpenAI, which "has exclusive access to a subset" (Epoch). v2 (June 12, 2026) fixed errors in 42% of problems, so don't join v1 and v2. Tier 4 v2 is saturated.
- FrontierMath-Erdos statements are public on GitHub; Epoch says no proofs were known as of Aug 2026.
- Release event: o1-mini on Sept 12, 2024 (MATH L5 53% to 89%, OTIS 10% to 47%).

## 3. `human_baseline_saturation.json` (mostly verifiable)

**What:** 15 records under `benchmarks`. Each record has `benchmark`, `metric`, `higher_is_better`, `introduced`, `human_baseline` (`value`, `definition`, `source`, `alt`), `saturation`, and `points` (84 in total). The points are the record-setting best AI score per year, plus the first result above the human figure (`first_above_human: true`). `source_kind` says where a point comes from: paper or official leaderboard, lab-reported, or Epoch AI hub.

| Benchmark | Human figure | First passed | Notes |
|---|---|---|---|
| MNIST | 0.2% error | about 2012-2013 | weak author estimate, LeCun et al. 1995 |
| ImageNet | 5.1% top-5 error | Feb 6, 2015 (PReLU-net) | one annotator, 1,500 images |
| SQuAD 1.1 | 82.304 EM | EM Jan 3, 2018; F1 Sept 26, 2018 | |
| SQuAD 2.0 | 86.831 EM | Mar 20, 2019 | |
| GLUE | 87.1 | June 7, 2019 | |
| SuperGLUE | 89.8 | Jan 6, 2021 | |
| MMLU | 89.8 expert estimate | Dec 6, 2023 (Gemini Ultra, CoT@32) | non-expert 34.5 |
| HellaSwag | 95.6 | never officially passed | top is 95.3 |
| BBH | 67.7 average rater | at introduction, Oct 2022 | max rater 94.4, still not passed |
| GPQA Diamond | 69.7 (OpenAI's PhD experts) | Sept 2024 (o1-preview) | the paper's 81.3 validator figure passed Mar 2025 |
| ARC-AGI-1 | 64.2 (H-ARC average) | Dec 20, 2024 (o3-preview, unreleased) | panel 98% matched June 2026 |
| ARC-AGI-2 | 60 (average test-taker) | Feb 2026 | |
| MATH | 90 (IMO gold medalist, 18 of 20 problems) | Dec 2024 (o1, Level 5) | |
| GSM8K | none published | n/a | no measured human baseline; context points only |
| HumanEval | none published | n/a | no measured human baseline; context points only |

**Sources:**
- **Original papers.** arXiv links on every point. Key ones: 1409.0575 (ImageNet human), 1606.05250 and 1806.03822 (SQuAD), 1905.10425 (GLUE human), 1905.00537 (SuperGLUE), 2009.03300 (MMLU), 1905.07830 (HellaSwag), 2210.09261 (BBH), 2311.12022 (GPQA), 2409.01374 (H-ARC), 2505.11831 (ARC-AGI-2), 2312.11805 (Gemini), 2210.11416 (Flan-PaLM).
- **Official results pages and leaderboards:** image-net.org/challenges/LSVRC, rajpurkar.github.io/SQuAD-explorer, gluebenchmark.com, super.gluebenchmark.com, rowanzellers.com/hellaswag, arcprize.org.
- **OpenAI's o1 post,** read from its Wayback copy http://web.archive.org/web/20241002020941/https://openai.com/index/learning-to-reason-with-llms/: MMLU 92.3, MATH-500 85.5 and 94.8, GPQA 73.3, 77.3 and 78.0.
- **Epoch AI CSVs** for the LLM era: `mmlu_external.csv`, `bbh_external.csv`, `gpqa_diamond.csv`, `arc_agi_external.csv`, `arc_agi_2_external.csv`, `gsm8k_external.csv`, `math_level_5.csv`.
- **Not used:** Our World in Data and Papers with Code. Papers with Code is defunct, and Wayback couldn't be reached from the research tool.

**License:** Epoch CC BY 4.0. Everything else is single published numbers, cited.

**Caveats:**
- "Human baseline" means very different things across benchmarks. See each `definition`.
- Leaderboards show one row per team, so superseded entries are invisible.
- Lab-reported first crossings (GPQA, MMLU, ARC-AGI-1, MATH) are often release events and use generous sampling (CoT@32, cons@64, high compute).
- Contamination is likely for every public set. About 6.5% of MMLU questions are wrong (arXiv 2406.04127). Some model families drop up to 8 points on the held-out GSM1k (arXiv 2405.00332).
- `date_precision`: "year" uses July 1 of that year and "month" uses the 1st, as placeholders only.

## 4. `preference.json` (judgment)

**What:** the #1 model's LMArena (Chatbot Arena) text score, monthly, 43 points: the last published snapshot of each month from May 2023 to Oct 15, 2026, plus May 8, 2023. Overall category, not style-controlled. Each point also gives the score of a fixed anchor in the same snapshot (GPT-4 of March 2023: `gpt-4-0314`, or the arena's single `gpt-4` entry before Dec 2023), the gap, and the implied chance a voter prefers the top model over that anchor, `1/(1+10^(-gap/400))`. The gap moved from 0 (May 2023) to 51 (Dec 2023), 101 (May 2024), 187 (Dec 2024), 274 (June 2025), 295 (Feb 2026) and 326 (Oct 2026), which is an 87% implied win rate against March-2023 GPT-4.

`other_series`:
- creative-writing category top (25 points, Oct 2024 to Oct 2026)
- style-controlled top (27 points)
- GDPval win-or-tie rate against industry professionals (11 points, Epoch's copy, 50 = parity)
- Remote Labor Index automation rate (17 points, Epoch's copy, human evaluators)
- 25 dated human-vs-model writing comparisons, each with `metric_kind`, `definition`, `reference_line`, `human_value`, `raters`, `n`, `genre`

**Elo is relative.** Arena scores rank models against each other. There is no human reference line, and one can't be drawn from this data. The anchored win probability is still model against model.

**Sources and how they were read:**
- **May 2023 to Aug 2025.** The snapshot files LMArena published at the time in its Hugging Face space, https://huggingface.co/spaces/lmarena-ai/arena-leaderboard (formerly lmsys/ and lmarena-ai/chatbot-arena-leaderboard), revision `6f2eeeba09bf42144dbc118fe1a8e12e4c533f9d`, files `elo_results_YYYYMMDD.pkl`. For May 2023 to Feb 2024 the value is the published markdown table inside each file. From Mar 2024 it is the `leaderboard_table_df` "full" table. The 2023 values match the `Arena Elo rating` column of the space's `leaderboard_table_*.csv` files. The pickles were never executed: a stub unpickler turned every class reference into an inert placeholder, and the tables were decoded from the raw buffers in pure Python.
- **Sept 2025 to Oct 2026.** LMArena's official dataset, https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset at commit `a64ca3b12b6e6fcb9e7747cd56131d8a8047d822` (`text/full-00000-of-00001.parquet`, `text_style_control/...`), CC BY 4.0.

**Why not the dataset for everything.** The dataset drops models LMArena later deprecated or renamed. Its 2023 rows have no proprietary models at all, and from Oct 2024 to May 2025 it is missing the #1 model in every month-end snapshot, which understates the top by 5 to 41 points. For Sept 2025 on, the dataset matched archived copies of the public leaderboard on Dec 16, 2025, Mar 11, 2026 and Sept 13, 2026 (same top models and scores): https://web.archive.org/web/20251217003357/https://lmarena.ai/leaderboard/text, https://web.archive.org/web/20260315234953/https://arena.ai/leaderboard/text, https://web.archive.org/web/20260914212514/https://arena.ai/leaderboard/text. The older snapshots turned out not to need git history: the space keeps every dated snapshot as its own file in the current revision.

**Scale changes:** Elo to Bradley-Terry (LMArena: Jan 9, 2024; the space files say "bt" from Dec 6, 2023); style control default (May 16, 2025); frequency re-weighting (July 23, 2025). The anchor sat near 1186 through Apr 2025 and near 1204 to 1212 afterwards, so part of the raw mid-2025 rise is scale. Plot `gap_vs_anchor` for trends. Changelog: https://arena.ai/blog/leaderboard-changelog/. Labs test private variants before release (Singh et al., "The Leaderboard Illusion", https://arxiv.org/abs/2504.20879), so the public top is a selected maximum.

**People-graded work with a human reference:**
- GDPval (OpenAI, https://arxiv.org/abs/2510.04374): 44 occupations, blind pairwise grading by industry experts on the 220-task gold set. OpenAI built it and ranks its own models. Epoch's later rows don't say whether experts or the automated grader produced them (v).
- Remote Labor Index (Scale AI and CAIS, https://arxiv.org/abs/2510.26787): every deliverable is evaluated manually by trained workers and experts. The paper's own best at v1 was 2.5%, which isn't in Epoch's rows.
- Both come from https://epoch.ai/data/benchmark_data.zip (`gdpval_external.csv`, `rli_external.csv`), CC BY 4.0.

**Writing studies:** 25 entries, 24 checked against the primary paper (journal page, arXiv, or the PMC/Europe PMC full text where the journal blocked fetching). The NYT quiz (Mar 9, 2026) is (v): its page couldn't be fetched. So is the GPT-5 attribution of the 59% figure in Jones and Bergen's PNAS version (press only). Key entries:
- Porter and Machery, Scientific Reports, Nov 14, 2024 (https://doi.org/10.1038/s41598-024-76900-1): 46.6% identification accuracy, below chance. AI poems were rated higher, and the authors attribute that to simplicity.
- Chakrabarty et al.: expert judges, New Yorker stories 84.7% vs 30.0% on the Torrance tests (2023); MFA experts reject prompted AI but prefer AI fine-tuned on an author's books (2025).
- Jones and Bergen Turing tests: 73% for GPT-4.5 with a persona prompt, 36% without (2025).
- Sears and Weisberg, JDM, Aug 2026: 39.4% identification accuracy on literary stories.
- Counterpoints: expert annotators detect AI text at 99.7% (Russell et al. 2025), and readers prefer human literary translation 68% of the time (Ferstler et al. 2026).

Do not draw one line through these studies. Lay vs expert raters, labels, text length, and the lag from data collection to publication all move the numbers (`model_or_data_date` where known). The LLM-judged writing benchmark in Epoch's hub (Lech Mazur) is excluded because a model is the grader.

**Licenses:** LMArena dataset CC BY 4.0. Space snapshot files are public, with no license field; only values are used, with credit. Epoch CC BY 4.0. Studies are cited for single published numbers.

## 5. `events.json`

25 dated events, each with `type` and one-line `note`.
- **The four requested types:** architecture, training recipe, scaling, release event.
- **Three extra types:** measurement (a chart's metric changed or stopped: Arena start, Elo to BT, style control, METR's paper and its freeze, FrontierMath v2), demonstration (third party using a released model: the GPT-6 Astra cipher, Oct 2, 2026), and claim (the withdrawn GPT-5 Erdos post, Oct 2025).
- The Oct 6, 2026 math release has `release_event: true` and `dump: true`: 722 manuscripts, about 4,000 problems posed, three withdrawn Oct 7, compute undisclosed. Sources: https://github.com/openai/math and https://retractionwatch.com/2026/10/08/openai-withdraws-preprints-722-manuscripts-unsolved-math-problems/.
- Sources are primary where reachable: arXiv, Nature, DeepMind, Anthropic, Epoch, METR, ARC Prize, GitHub.
- openai.com pages block automated fetching, so they are cited by their known URLs: ChatGPT, GPT-4, InstructGPT, o1, and the unit-distance post.
- (v) items: the Reuters Q*/Strawberry development history for o1; OpenAI's July 19, 2025 IMO post; the Navier-Stokes compute figures, taken via Wikipedia's summary of OpenAI's post; and the unit-distance announcement page, cited from the post's research files.

## What I could not get, or chose not to build

- **METR after April 2026: none exists.** METR froze its page on Sept 8, 2026. No horizon exists for Claude Opus 5/5.5, GPT-5.5/6, Gemini 4 or any other later model. The top point is a lower bound.
- **A logistic or exponential fit: not built.** These files hold measurements only. Any fitted curve is the chart's model.
- **LMArena:**
  - 2023 values are rounded integers from the published table.
  - Oct 2026 has a single mid-month snapshot (Oct 15).
  - Sept 2025 to Oct 2026 rests on LMArena's dataset, which drops deprecated models. I checked it against archived leaderboards on three dates, not every month.
- **Writing studies: no multi-year, same-protocol series exists.** The research pass found no study that reruns one creative-writing protocol across model generations. The closest are within-study comparisons: Herbold (GPT-3.5 vs GPT-4), Chakrabarty 2023, the Jones and Bergen Turing tests, and Anthropic's persuasion study, whose numbers appear only in a figure and so are not included.
- **Secondhand items (v):**
  - NYT AI-writing quiz (Mar 2026), page not fetched.
  - GPT-5 attribution of the 59% PNAS Turing result (press only).
  - GDPval grading method for Epoch's post-Sept-2025 rows.
- **MNIST: weak or secondhand.** The 0.2% "human" figure is an unmethodical 1995 estimate. The 2003, 2006 and 2013 points come from secondary tables (v). The 2002 virtual-SVM 0.56% point was dropped because no source was reachable.
- **ImageNet: 2013 date ambiguous.** The ILSVRC 2013 results date is ambiguous (`date_precision: approx`). Baidu's withdrawn 2015 result is excluded.
- **SQuAD:**
  - The 1.1 human figure changed from 77.0/86.8 (paper) to 82.304/91.221 (leaderboard), and I found no explanation.
  - The 2016 logistic-regression EM of 40.4 is (v).
  - Leaderboards hide superseded entries.
- **GLUE gaps:** OpenAI GPT's about 72.8 (2018) and Baidu ERNIE 90.1 (Dec 2019) are omitted or noted as (v). The 2020 leader is uncertain.
- **SuperGLUE gap:** T5 + Meena 90.2 on Jan 5, 2021 is press-only (v). The first verified crossing is Jan 6.
- **HellaSwag:** UNICORN's 93.9 is from its paper. No leaderboard entry above 95.6 was found.
- **ARC-AGI-1:** the 2020 Kaggle date is approximate (v). ARCathon 2023 is year-only. The eval sets differ: hidden test, private and semi-private.
- **HumanEval: no series built.** There is no human baseline and no Epoch file.
- **Toby Ord's constant-hazard fit: not reproduced here.** The draft cites it for METR.
- **Scripts not included.** The builds were done with throwaway scripts in the session scratchpad. The METR, Epoch and LMArena steps are reproducible from the cited files: METR YAMLs copied as-is; Epoch CSVs taken as the running max by release date; LMArena month-end snapshots.
