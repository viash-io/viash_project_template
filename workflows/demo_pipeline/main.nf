nextflow.enable.dsl=2

targetDir = "${params.rootDir}/target/nextflow"

include { remove_comments } from "$targetDir/demo/remove_comments/main.nf"
include { take_column }     from "$targetDir/demo/take_column/main.nf"
include { combine_columns } from "$targetDir/demo/combine_columns/main.nf"

workflow {
  Channel.fromPath(params.input)
  
    // Assign unique ID to each event
    //   File -> (String, File)
    | map { file -> [ file.baseName, file ] }
    
    // Remove comments from TSV
    //   (String, File) -> (String, File)
    | remove_comments

    // Extract single column from TSV
    //   (String, File) -> (String, File)
    | take_column

    // Combine all events into a single List event
    //   (String, File)* -> List[(String, File)]
    | toList()

    // Add unique ID to tuple
    //   List[(String, File)] -> (String, {input: List[File]})
    | map { tups -> 
      files = tups.collect{id, file -> file}
      [ "combined", [ input: files ] ] 
    }

    // Concatenate TSVs into one
    //   (String, {input: List[File]}) -> (String, File)
    | combine_columns.run(
      auto: [ publish: true ]
      )

    // View channel contents
    | view { tup -> "Output: $tup" }
}
