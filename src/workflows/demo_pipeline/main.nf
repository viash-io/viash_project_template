workflow run_wf {
  take:
    input_ch

  main:

    output_ch =

      input_ch

        // Turn the Channel event with list of files
        // into multiple Channel events with one file.
        | expand.run(
            fromState: { id, state -> state },
            toState: {id, result, state -> 
              _mergeMap(state, [ expanded: result.output ])
            }
          )

        // Remove comments from each TSV input file
        | remove_comments.run(
            fromState: { id, state -> [ input: state.expanded ] },
            toState: { id, result, state -> 
              _mergeMap(state, [ remove_comments: result.output ] ) }
          )

        // Extract single column from each TSV
        | take_column.run(
            fromState: { id, state -> [ input: state.remove_comments ] },
            toState: {id, result, state ->
              _mergeMap(state, [ take_column: result.output ])
            }
          )

        // Custom toSortedList
        | vsh_toList.run (
            fromState: { id, state -> [ id: "run", input: state.take_column ] },
            toState: { id, result, state -> result }
          )

        // Concatenate TSVs into one
        | combine_columns.run(
            auto: [ publish: true ],
            fromState: { id, state -> [ input: state.output ] },
            toState: { id, result, state -> result }
          )

        // View channel contents
        | niceView()

  emit:
    output_ch
}
