# Data

Anonymized data used in the analysis.

## Experiment I

- `adjacency_matrix.csv`: adjacency matrix of the graph of aggregated
  responses, with weighted edges.
- `node_labels.json`: room labels of the graph nodes, to reconstruct the
  graph.
- `allParams.csv`: room-acoustic parameters of each room ($T_{20}$,
  $C_{50}$, $J_\mathrm{LF}$, and DRR in the octave bands from 125 Hz to 4 kHz).

## Experiment II

- `experimentResults.csv`: participant responses, one row per trial. The
  columns used in the analysis are described in
  `code/experiment2/Analysis.Rmd`.
- `surveys.csv`: questionnaire answers, one row per participant.
