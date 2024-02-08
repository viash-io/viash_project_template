workflow run_wf {
  take:
    input_ch

  main:

    output_ch =

      input_ch

        // Remove comments from each TSV input file
        | remove_comments.run(
            fromState: [ input: "input" ],
            toState: { id, result, state -> state + result }
          )

        // Extract a single column from each TSV
        // The column to extract is specified in the sample sheet
        | take_column.run(
            fromState:
              [
                input: "output",
                column: "column"
              ],
            toState: { id, result, state -> result }
          )

        // Helper module with extra functionality around
        // nextflow's `toSortedList` operator to reformat 
        // its output list into a channel item that can be used
        // directly with downstream components.
        | vsh_toList.run(
            fromState: { id, state ->
              [
                id: id,
                input: state.output
              ]
            },
            toState: [ output: "output" ]
          )

        // Concatenate TSVs into one
        // and prep the output state.
        | combine_columns.run(
            auto: [ publish: true ],
            fromState: [ input: "output" ],
            toState: { id, result, state -> result }
          )

  emit:
    output_ch
}
