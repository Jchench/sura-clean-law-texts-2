library("quanteda")

# Define documents
documentA <- paste(readLines("ocr_txt/PL116_283.txt"), collapse = "\n")
documentB <- paste(readLines("gpt_txt/PL116_283_gpt.txt"), collapse = "\n")

# Preprocess the documents
preprocess <- function(doc) {
  doc <- tolower(doc) 
  doc <- gsub("[[:punct:]]", "", doc) 
  doc <- gsub("\\s+", " ", doc)
  return(doc)
}

documentA <- preprocess(documentA)
documentB <- preprocess(documentB)

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

# Print the results
cat("Proportion of 10-grams from document A not in document B:", proportionA_not_in_B, "\n")
cat("Proportion of 10-grams from document B not in document A:", proportionB_not_in_A, "\n")

# Get and print examples of 10-grams unique to each document
unique_to_A <- setdiff(setA, setB)
unique_to_B <- setdiff(setB, setA)

# Print a few examples
cat("\nExamples of 10-grams in document A but not in document B:\n")
print(head(unique_to_A, 10))

cat("\nExamples of 10-grams in document B but not in document A:\n")
print(head(unique_to_B, 10))