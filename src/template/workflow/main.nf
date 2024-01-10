workflow run_wf {
  take:
    input_ch

  main:

    output_ch =

      input_ch

        // Turn the Channel event with a list of files
        // into multiple Channel events with one file.
        // This involves either expanding a globbing parameter
        // or multiple input files seperated by a `;`.
        | vsh_flatten

        // Remove comments from each TSV input file
        | remove_comments.run(
            fromState: [ input: "output" ],
          )

        // Extract a single column from each TSV
        | take_column.run(
            fromState: [ input: "output" ],
          )

        // Helper module with extra functionality around
        // nextflow's `toSortedList` operator to reformat 
        // its output list into a channel item that can be used
        // directly with downstream components.
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
