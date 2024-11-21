
custom_data_a <- feather::read_feather(here::here("output", "dummy_dataset_2a.arrow"))
custom_data_b <- feather::read_feather(here::here("output", "dummy_dataset_2b.arrow"))

ehrql_data <- readr::read_csv(here::here("output", "dataset_2.csv.gz"))
ehrql_data <- feather::read_feather(here::here("output", "dataset_2.arrow"))

