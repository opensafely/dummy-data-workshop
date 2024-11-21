library(dplyr)
library(dd4d)

set.seed(314159)

pop_n <- 1000
index_date <- as.Date("2020-12-08")

pfizer_name <- "COVID-19 mRNA Vaccine Comirnaty 30micrograms/0.3ml dose conc for susp for inj MDV (Pfizer)"
az_name <- "COVID-19 Vaccine Vaxzevria 0.5ml inj multidose vials (AstraZeneca)"


# define each variable as a node in a bayesian network

sim_list <- lst(
  
  registered = bn_node(
    ~ rbernoulli(n = ..n, p = 0.99)
  ),
  
  age = bn_node(
    ~ as.integer(rnorm(..n, mean= 55, sd=20)),
  ),
  
  sex = bn_node(
    ~ rfactor(n = ..n, levels = c("female", "male", "intersex", "unknown"), p = c(0.50, 0.49, 0, 0.01)),
    missing_rate = ~0.001 # this is shorthand for ~(rbernoulli(n=..n, p = 0.2))
  ),
  
  diabetes = bn_node(
    ~ rbernoulli(n = ..n, p = 0.10)
  ),

  vaccine_day1 = bn_node(
    ~ runif(n = ..n, 0, 150),
    missing_rate = ~0.2,
  ),
  vaccine_day2 = bn_node(
    ~ vaccine_day1 + runif(n = ..n, 3*7, 16*7),
    missing_rate = ~0.001,
    needs = "vaccine_day2"
  ),
  
  vaccine_product1 = bn_node(~ rcat(n = ..n, c("pfizer", "az"), c(0.5, 0.5)), needs = "vaccine_day1"),
  vaccine_product2 = bn_node(~ if_else(runif(..n) < 0.95, vaccine_product1, "az"), needs = "vaccine_day2"),

)

bn <- bn_create(sim_list)

# plot the network
bn_plot(bn)

# plot the network (connected nodes only)
bn_plot(bn, connected_only = TRUE)

# simulate the dataset
dummy_data <- bn_simulate(bn, pop_size = pop_n, keep_all = FALSE, .id = "patient_id")

dummy_data_days_to_dates <- dummy_data %>%
  mutate(across(num_range("vaccine_day", 1:2), ~ index_date + .)) %>%
  rename_with(~ stringr::str_replace(., "_day", "_date"), starts_with("vaccine_day"))

# write to arrow file
feather::write_feather(dummy_data_days_to_dates, path = here::here("output", "dummy_dataset_2b.arrow"))

