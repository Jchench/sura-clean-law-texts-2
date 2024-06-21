library("quanteda")

# Define documents
documentA <- as.character(read.delim("ocr_txt/PL069_639.txt"))
documentB <- as.character(read.delim("gpt_txt/PL069_639_gpt.txt"))

# Create tokens for both documents
tokensA <- tokens(documentA, what = "word")
tokensB <- tokens(documentB, what = "word")

# Generate 10-grams
tokensA_10grams <- tokens_ngrams(tokensA, n = 10)
tokensB_10grams <- tokens_ngrams(tokensB, n = 10)

# Convert tokens to unique sets of 10-grams
setA <- unique(as.character(tokensA_10grams[[1]]))
setB <- unique(as.character(tokensB_10grams[[1]]))

# Calculate the proportions
proportionA_not_in_B <- length(setdiff(setA, setB)) / length(setA)
proportionB_not_in_A <- length(setdiff(setB, setA)) / length(setB)

# Print the results
cat("Proportion of 10-grams from document A not in document B:", proportionA_not_in_B, "\n")
cat("Proportion of 10-grams from document B not in document A:", proportionB_not_in_A, "\n")
