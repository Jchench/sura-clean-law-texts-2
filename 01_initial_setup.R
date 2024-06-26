library(quanteda)
library(tidyverse)

# Function to process a pair of documents
process_documents <- function(doc_path_A, doc_path_B, law_name) {
  # Read and collapse the documents
  documentA <- paste(readLines(doc_path_A), collapse = "\n")
  documentB <- paste(readLines(doc_path_B), collapse = "\n")
  
  # Preprocess the documents
  preprocess <- function(doc) {
    doc <- tolower(doc)
    doc <- gsub("[[:punct:]]", "", doc)
    doc <- gsub("\\s+", " ", doc)
    return(doc)
  }
  
  documentA <- preprocess(documentA)
  documentB <- preprocess(documentB)
  
  # Word count
  count_should <- str_count(documentA, "\\bshould\\b")
  count_may <- str_count(documentA, "\\bmay\\b")
  count_should_not <- str_count(documentA, "\\bshould+not\\b")
  count_may_not <- str_count(documentA, "\\bmay+not\\b")
  
  count_should_B <- str_count(documentB, "\\bshould\\b")
  count_may_B <- str_count(documentB, "\\bmay\\b")
  count_should_not_B <- str_count(documentB, "\\bshould+not\\b")
  count_may_not_B <- str_count(documentB, "\\bmay+not\\b")
  
  # Save word counts
  word_count <- tibble(
    law = law_name,
    "# should" = count_should,
    "# may" = count_may,
    "# should not" = count_should_not,
    "# may not" = count_may_not,
    "# should in gpt" = count_should_B,
    "# may in gpt" = count_may_B,
    "# should not in gpt" = count_should_not_B,
    "# may not in gpt" = count_may_not_B
  )
  
  assign(paste0(law_name, "_word_count"), word_count, envir = .GlobalEnv)
  
  save(word_count, file = paste0("results/", law_name, "_word_count.rda"))
  
  # Create tokens for both documents
  tokensA <- tokens(documentA, what = "word")
  tokensB <- tokens(documentB, what = "word")
  
  # Generate 10-grams
  tokensA_10grams <- tokens_ngrams(tokensA, n = 10)
  tokensB_10grams <- tokens_ngrams(tokensB, n = 10)
  
  # Convert tokens to unique sets of 10-grams and eliminate those with numbers
  filter_ngrams <- function(ngrams) {
    ngrams <- unique(as.character(ngrams[[1]]))
    ngrams <- ngrams[!grepl("[0-9]", ngrams)]
    return(ngrams)
  }
  
  setA <- filter_ngrams(tokensA_10grams)
  setB <- filter_ngrams(tokensB_10grams)
  
  # Calculate the proportions
  proportionA_not_in_B <- length(setdiff(setA, setB)) / length(setA)
  proportionB_not_in_A <- length(setdiff(setB, setA)) / length(setB)
  
  # Save the results
  accuracy <- tibble(
    law = law_name,
    ocr = proportionA_not_in_B,
    gpt = proportionB_not_in_A
  )
  
  assign(paste0(law_name, "_accuracy"), accuracy, envir = .GlobalEnv)
  
  save(accuracy, file = paste0("results/", law_name, "_accuracy.rda"))
  
  # Get examples of 10-grams unique to each document
  unique_to_A <- setdiff(setA, setB)
  unique_to_B <- setdiff(setB, setA)
  
}

# List of document pairs and law names
document_pairs <- list(
  list("machine_readable/PL093_495_1551.txt", "gpt_txt/PL093_495_1551_gpt.txt", "PL093_495_1551"),
  list("machine_readable/PL094_200.txt", "gpt_txt/PL094_200_gpt.txt", "PL094_200"),
  list("machine_readable/PL094_239.txt", "gpt_txt/PL094_239_gpt.txt", "PL094_239"),
  list("machine_readable/PL094_240.txt", "gpt_txt/PL094_240_gpt.txt", "PL094_240"),
  list("machine_readable/PL098_181_1278.txt", "gpt_txt/PL098_181_1278_gpt.txt", "PL098_181_1278"),
  list("machine_readable/PL102_242_2334.txt", "gpt_txt/PL102_242_2334_gpt.txt", "PL102_242_2334"),
  list("machine_readable/PL102_550.txt", "gpt_txt/PL102_550_gpt.txt", "PL102_550"),
  list("machine_readable/PL104_208.txt", "gpt_txt/PL104_208_gpt.txt", "PL104_208"),
  list("machine_readable/PL105_310.txt", "gpt_txt/PL105_310_gpt.txt", "PL105_310")
)

# Process each document pair
for (pair in document_pairs) {
  process_documents(pair[[1]], pair[[2]], pair[[3]])
}
