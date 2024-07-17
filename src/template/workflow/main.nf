workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      // Remove comments from each TSV input file
      | remove_comments.run(
        fromState: [ input: "input" ],
        toState: [ output: "output" ]
      )

      // Extract a single column from each TSV
      // The column to extract is specified in the sample sheet
      | take_column.run(
        fromState: [
          input: "output",
          column: "column"
        ],
        toState: [ output: "output" ]
      )

      // Combine the given tuples into one
      | toSortedList

      | map { list ->
        def new_id = "combined"
        def new_state = [
          input = list.collect{ id, state -> state.output },
          _meta: [ join_id: list[0][1] ]
        ]
        [ new_id, new_state ]
      }

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