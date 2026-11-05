////////////////////////////////////////////////////////////////////////////////
// Memory for Room Acoustics, Stan Model
//
// Sergio de las Heras, 2025
// sergio.delasheras@aalto.fi
//
// Hierarchical signal detection model for a same/different task with a
// retention interval, probit link:
//
//   R_n     ~ Bernoulli(Phi(eta_n))
//   eta_n   = -c_j + d_{j,k} * delta_n * X_n
//   delta_n = a_k / (a_k + dt_n^b_k)          (delta = 1 at dt = 0)
//
//   c_j     ~ N(beta_crit, sigma_crit)         participant criterion
//   d_{j,k} ~ N(beta_fam_k, sigma_fam)         participant d' per condition
//
// R = 1 means the participant answered "same"; X = 1 for same trials.
// For different trials P(say "same") = Phi(-c), i.e. c sets the false alarm rate.
//
// Speech condition index (k): 1 = DS (different speaker, sameSpeaker = 0)
//                             2 = SS (same speaker,      sameSpeaker = 1)
//
// Set prior_only = 1 to sample from the prior (prior predictive check);
// y_rep then contains simulated data.
////////////////////////////////////////////////////////////////////////////////

functions {
  // Linear predictor for every trial
  vector linear_predictor(vector X, vector dt,
                          array[] int k, array[] int pid, array[] int idx_d,
                          vector a, vector b, vector c, matrix dprime) {
    // Decay: delta = 1 at dt = 0
    vector[rows(dt)] delta;
    for (n in 1:rows(dt))
      delta[n] = dt[n] == 0 ? 1 : a[k[n]] / (a[k[n]] + dt[n]^b[k[n]]);
    return -c[pid] + to_vector(dprime)[idx_d] .* delta .* X;
  }
}

data {
  int<lower=1> N;                                    // Number of trials
  array[N] int<lower=0, upper=1> X;                  // 1 = same trial
  array[N] int<lower=0, upper=1> R;                  // 1 = answered "same"

  int<lower=1> K_speech;                             // Speech conditions (2)
  array[N] int<lower=1, upper=K_speech> k_speech;    // 1 = DS, 2 = SS

  vector<lower=0>[N] deltaT;                         // Retention interval (s)

  int<lower=1> J_participants;                       // Number of participants
  array[N] int<lower=1, upper=J_participants> pid;   // Participant IDs

  int<lower=0, upper=1> prior_only;                  // 1 = ignore the data
}

transformed data {
  vector[N] Xv = to_vector(X);

  // Position of dprime[pid[n], k_speech[n]] in to_vector(dprime) wich stacks
  // the second dimension
  array[N] int idx_d;
  for (n in 1:N)
    idx_d[n] = (k_speech[n] - 1) * J_participants + pid[n];
}

parameters {
  real beta_crit;                                    // Population criterion
  real<lower=0> sigma_crit;                          // SD of criterion

  vector[K_speech] beta_fam;                         // Population d' per condition
  real<lower=0> sigma_fam;                           // SD of d'

  // Non-centered participant effects
  vector[J_participants] z_crit;
  matrix[J_participants, K_speech] z_fam;

  vector<lower=0>[K_speech] a_decay;                 // Decay parameter a
  vector<lower=0>[K_speech] b_decay;                 // Decay parameter b
}

transformed parameters {
  vector[J_participants] c = beta_crit + sigma_crit * z_crit;
  matrix[J_participants, K_speech] dprime
    = rep_matrix(beta_fam', J_participants) + sigma_fam * z_fam;
}

model {
  // Priors
  beta_fam[1] ~ normal(2, 1);                        // DS
  beta_fam[2] ~ normal(4, 1);                        // SS
  sigma_fam ~ lognormal(-0.5, 0.2);

  beta_crit ~ normal(1, 1);
  sigma_crit ~ lognormal(-0.5, 0.2);

  a_decay ~ lognormal(2, 1);
  b_decay ~ normal(0, 1);                            // Half-normal (lower=0)

  // Participant effects
  z_crit ~ std_normal();
  to_vector(z_fam) ~ std_normal();

  // Likelihood
  if (!prior_only) {
    vector[N] eta = linear_predictor(Xv, deltaT, k_speech, pid, idx_d,
                                     a_decay, b_decay, c, dprime);
    R ~ bernoulli(Phi(eta));
  }
}

generated quantities {

  real beta_fam_diff = beta_fam[2] - beta_fam[1];    // SS - DS
  real a_diff = a_decay[2] - a_decay[1];             // SS - DS
  real b_diff = b_decay[2] - b_decay[1];             // SS - DS

  // Replicated data (posterior or prior predictive)
  array[N] int y_rep;
  {
    vector[N] eta = linear_predictor(Xv, deltaT, k_speech, pid, idx_d,
                                     a_decay, b_decay, c, dprime);
    y_rep = bernoulli_rng(Phi(eta));
  }
}
