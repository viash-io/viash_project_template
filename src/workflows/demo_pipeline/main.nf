workflow run_wf {
  take:
    input_ch

  main:

    output_ch =

      input_ch

        // Turn the Channel event with list of files
        // into multiple Channel events with one file.
        | expand

        // Remove comments from each TSV input file
        | remove_comments.run(
            fromState: [ input: "output" ],
          )

        // Extract single column from each TSV
        | take_column.run(
            fromState: [ input: "output" ],
          )

        // Custom toSortedList
        | vsh_toList.run(
            args: [ id: "run" ],
            fromState: [ input: "output" ],
          )

        // Concatenate TSVs into one
        | combine_columns.run(
            auto: [ publish: true ],
            fromState: [ input: "output" ],
          )

        // View channel contents
        | niceView()

  emit:
    output_ch
}
