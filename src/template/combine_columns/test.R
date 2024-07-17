cat("Generating test data\n")

df1 <- data.frame(
  a = c(1, 2, 3),
  b = c(4, 5, 6)
)

df2 <- data.frame(
  c = c("a", "b", "c"),
  d = c(TRUE, FALSE, TRUE)
)

write.table(df1, "file1.tsv", col.names = FALSE, row.names = FALSE, sep = "\t")
write.table(df2, "file2.tsv", col.names = FALSE, row.names = FALSE, sep = "\t")

paste0("Running ", meta$name, "\n")
zz <- processx::run(
  command = meta$executable,
  args = c(
    "--input", "file1.tsv",
    "--input", "file2.tsv",
    "--output", "foo.tsv"
  )
)

cat("Checking results\n")
table <- read.delim("foo.tsv", header = FALSE)
expected_table <- cbind(df1, df2)
colnames(table) <- colnames(expected_table) <- NULL
testthat::expect_equal(table, expected_table)

cat("Test successful\n")