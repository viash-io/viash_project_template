
## VIASH START
par <- list(
    input = c("data/file1.tsv", "data/file2.tsv"),
    output = "temp/foo.tsv"
)
## VIASH END

outs <- lapply(par$input, function(file) {
  read.delim(file, comment.char = "#", sep = "\t", header = FALSE)
})

table <- do.call(cbind, outs)

write.table(table, par$output, col.names = FALSE, sep = "\t")