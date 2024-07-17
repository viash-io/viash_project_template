workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      | view{"input: $it"}

      // Remove comments from each TSV input file
      | remove_comments.run(
        fromState: [ input: "input" ],
        toState: [ output: "output" ]
      )

      | view{"after remove_comments: $it"}

      // Extract a single column from each TSV
      // The column to extract is specified in the sample sheet
      | take_column.run(
        fromState: [
          input: "output",
          column: "column"
        ],
        toState: [ output: "output" ]
      )

      | view{"after take_column: $it"}

      // Combine the given tuples into one
      | toSortedList

      | map { state_list ->
        def new_id = "combined"
        def new_state = [
          input: state_list.collect{ id, state -> state.output },
          _meta: [ join_id: state_list[0][0] ]
        ]
        [ new_id, new_state ]
      }

      | view{"before combine_columns: $it"}

      // Concatenate TSVs into one
      // and prep the output state.
      | combine_columns.run(
        auto: [ publish: true ],
        fromState: [ input: "input" ],
        toState: ["output": "output"]
      )

      | view{"after combine_columns: $it"}

      // make sure the output state only contains
      // a value called 'output' and '_meta'
      | setState(["output", "_meta"])

  emit:
    output_ch
}