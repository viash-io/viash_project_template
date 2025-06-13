## VIASH START
par <- list(
  input = c("resources_test/file1.tsv", "resources_test/file2.tsv"),
  output = "temp/foo.tsv"
)
## VIASH END

outs <- lapply(par$input, function(file) {
  read.delim(file, comment.char = "#", sep = "\t", header = FALSE)
})

table <- do.call(cbind, outs)

write.table(table, par$output, row.names = FALSE, col.names = FALSE, sep = "\t")

