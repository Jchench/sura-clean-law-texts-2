library(tidyverse)

load("results/PL093_495_1551.rda")
load("results/PL094_200.rda")
load("results/PL094_239.rda")
load("results/PL094_240.rda")
load("results/PL098_181_1278.rda")
load("results/PL102_242_2334.rda")
load("results/PL102_550.rda")
load("results/PL104_208.rda")
load("results/PL105_310.rda")
load("results/PL116_283.rda")

# accuracy
accuracy_table <- 
  PL093_495_1551_accuracy |> 
  bind_rows(PL094_200_accuracy) |> 
  bind_rows(PL094_239_accuracy) |> 
  bind_rows(PL094_240_accuracy) |> 
  bind_rows(PL098_181_1278_accuracy) |> 
  bind_rows(PL102_242_2334_accuracy) |> 
  bind_rows(PL102_550_accuracy) |> 
  bind_rows(PL104_208_accuracy) |> 
  bind_rows(PL105_310_accuracy) |> 
  bind_rows(PL116_283_accuracy)

# save
write_csv(accuracy_table, file = "accuracy_table.csv")
