workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      /*
        Remove comments from each TSV input file
        
        Example of an element in the channel at this stage:
        
          [ "myid", [ input: "path/to/input.tsv", column: 3 ] ]
      */
      | remove_comments.run(
        fromState: [ input: "input" ],
        toState: [ data_comments_removed: "output" ]
      )

      /*
        Extract a single column from each TSV
        
        Example of an element in the channel at this stage:
        
          [
            "myid",
            [
              input: "path/to/input.tsv",
              column: 3,
              data_comments_removed: "work/path/to/output.tsv"
            ]
          ]
      */
      | take_column.run(
        fromState: [
          input: "data_comments_removed",
          column: "column"
        ],
        toState: [ data_one_column: "output" ]
      )

      // Combine the given tuples into one
      | toSortedList

      | map { state_list ->
        def new_id = "combined"
        def new_state = [
          input: state_list.collect{ id, state -> state.data_one_column },
          // store the original id in the _meta field
          _meta: [ join_id: state_list[0][0] ]
        ]
        [ new_id, new_state ]
      }

      /*
        Combine the TSV files into one
        
        Example of an element in the channel at this stage:
        
          [
            "combined",
            [
              input: [ "path/to/output1.tsv", "path/to/output2.tsv" ],
              _meta: [ join_id: "myid" ]
            ]
          ]
      */
      | combine_columns.run(
        fromState: [ input: "input" ],
        toState: [ output: "output" ]
      )

      // make sure the output state only contains
      // a value called 'output' and '_meta'
      | setState(["output", "_meta"])

  emit:
    output_ch
}