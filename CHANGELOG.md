# viash_project_template 0.2.0

* Update viash to 0.6.7. This also fixes an error when nextflow complains that `scriptPath` is not defined.

* Replace 'underscore' (like `viash_build`) commands with equivalent 'ns' command (`viash ns build`).

# viash_project_template 0.1.0

First release of the project template repository.

Components:

* `src/demo/remove_comments`: A Bash-based component to remove all lines starting with a comment character `#`.

* `src/demo/take_column`: A Python-based component to extract a specific column from a TSV file.

* `src/demo/combine_columns`: An R-based component to combine multiple TSV files into one.

Pipelines:

* `workflows/demo_pipeline/main.nf`: A demo pipeline which uses abovementioned components.