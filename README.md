# Bayesian modeling of room-acoustic memory with same and different speech signals

Companion repository for the paper "Bayesian modeling of room-acoustic
memory with same and different speech signals", submitted to the Journal
of the Acoustical Society of America. It contains the anonymized data, the
analysis scripts for Experiments I and II, and the Bayesian signal
detection model, to reproduce the results and figures of the paper.

## Structure

- `data/`: anonymized data from Experiment I and Experiment II. See
  `data/README.md`.
- `code/experiment1/`: analysis of Experiment I (Jupyter notebook).
- `code/experiment2/`: analysis of Experiment II (R Markdown) and the
  Bayesian signal detection model implemented in Stan, under
  `code/experiment2/stan/`. See `code/README.md`.
- `doc/figs/`: output folder for the figures produced by the scripts.

## Citation

If you use the data or code, please cite the paper:

> de las Heras, S., Meyer-Kahlen, N., Llorca-Bofí, J., Schlecht, S. J.,
> Lokki, T., and Arend, J. M. (2026). "Bayesian modeling of room-acoustic
> memory with same and different speech signals," J. Acoust. Soc. Am.
> (submitted).

```bibtex
@article{delasheras2026bayesian,
  author  = {de las Heras, Sergio and Meyer-Kahlen, Nils and
             Llorca-Bof{\'i}, Josep and Schlecht, Sebastian J. and
             Lokki, Tapio and Arend, Johannes M.},
  title   = {Bayesian modeling of room-acoustic memory with same and
             different speech signals},
  journal = {The Journal of the Acoustical Society of America},
  year    = {2026},
  note    = {Submitted}
}
```

## License

The code and data are released under the MIT License. See `LICENSE`.
