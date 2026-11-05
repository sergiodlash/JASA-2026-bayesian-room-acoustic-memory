# Code

Scripts to reproduce the data summaries, the figures, and the Bayesian
model of the paper. Both scripts read the data from `data/` and, when
enabled, save the figures to `doc/figs/`. Run each script from its own
folder, since all paths are relative to it.

## Experiment I

`experiment1/analysis.ipynb` builds the graph of aggregated responses,
finds the room communities, and relates them to the room-acoustic
parameters (PCA and LDA). Set `savePlots = True` to write the figures to
`doc/figs/`.

The Python environment (Python 3.9 with `numpy`, `pandas`, `matplotlib`,
`seaborn`, `networkx`, `netgraph`, and `scikit-learn`) is described in
`experiment1/environment.yml`. To create it with conda and open the
notebook in it:

```sh
conda env create -f experiment1/environment.yml
conda activate room-acoustic-memory
cd experiment1
jupyter lab analysis.ipynb
```

## Experiment II

`experiment2/Analysis.Rmd` contains the descriptive analysis, the prior
predictive checks, the model fit, the posterior predictive checks, and the
posterior contrasts. `experiment2/Analysis.html` is the knitted output.

- The model is in `experiment2/stan/room-acoustic-memory.stan`.
- The fitted posterior and prior samples are saved in
  `experiment2/room-acoustic-memory_fit.rds` and
  `experiment2/room-acoustic-memory_prior.rds`. By default the script
  loads them; set `refit <- TRUE` to sample the models again.
- Set `savePlots <- TRUE` to write the figures to `doc/figs/`.

The analysis was run with R 4.6.1, `tidyverse` 2.0.0, `patchwork` 1.3.2,
`rstan` 2.32.7, `bayesplot` 1.15.0, `tidybayes` 3.0.7, `tm` 0.7.18, and
`sdlhRTools` 0.1.0 (<https://github.com/sergiodlash/sdlhRTools>). The
exact versions of all packages are recorded in `experiment2/renv.lock`.
To install them, run from `experiment2/`:

```r
install.packages("renv")
renv::restore()
```

The figures use the Latin Modern Roman font if it is installed, and the
default serif font otherwise.
