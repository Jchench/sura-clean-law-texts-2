library(tidyverse)

load("results/PL093_495_1551_accuracy.rda")
load("results/PL094_200_accuracy.rda")
load("results/PL094_239_accuracy.rda")
load("results/PL094_240_accuracy.rda")
load("results/PL098_181_1278_accuracy.rda")
load("results/PL102_242_2334_accuracy.rda")
load("results/PL102_550_accuracy.rda")
load("results/PL105_310_accuracy.rda")

# accuracy
accuracy_table <- 
  PL093_495_1551_accuracy |> 
  bind_rows(PL094_200_accuracy) |> 
  bind_rows(PL094_239_accuracy) |> 
  bind_rows(PL094_240_accuracy) |> 
  bind_rows(PL098_181_1278_accuracy) |> 
  bind_rows(PL102_242_2334_accuracy) |> 
  bind_rows(PL102_550_accuracy) |> 
  bind_rows(PL105_310_accuracy)

# save
write_csv(accuracy_table, file = "accuracy_table.csv")

# word count
load("results/PL093_495_1551_word_count.rda")
load("results/PL094_200_word_count.rda")
load("results/PL094_239_word_count.rda")
load("results/PL094_240_word_count.rda")
load("results/PL098_181_1278_word_count.rda")
load("results/PL102_242_2334_word_count.rda")
load("results/PL102_550_word_count.rda")
load("results/PL105_310_word_count.rda")

word_count_table <- 
  PL093_495_1551_word_count |> 
  bind_rows(PL094_200_word_count) |> 
  bind_rows(PL094_239_word_count) |> 
  bind_rows(PL094_240_word_count) |> 
  bind_rows(PL098_181_1278_word_count) |> 
  bind_rows(PL102_242_2334_word_count) |> 
  bind_rows(PL102_550_word_count) |> 
  bind_rows(PL105_310_word_count)

word_count_table <- 
  word_count_table |> 
  janitor::clean_names() |> 
  mutate(prop_should = number_should / number_should_in_gpt,
         prop_should_not = number_should_not / number_should_not_in_gpt,
         prop_may = number_may / number_may_in_gpt,
         prop_may_not = number_may_not / number_may_not_in_gpt)

# save
write_csv(word_count_table, file = "word_count_table.csv")

