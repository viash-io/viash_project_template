# viash_project_template 0.3.0

* Update to Viash 0.8.2

    * `demo_pipeline` is now built from `src/workflows/demo_pipeline`
    * State management overhaul
    * Use of helper functions (dependencies) from [`vsh_utils`](https://viash-hub.com/data-intuitive/vsh_utils)

# viash_project_template 0.2.0

* Update to Viash 0.7.1.

* Replace 'underscore' (like `viash_build`) commands with equivalent 'ns' command (`viash ns build`).

* Use slim versions of the previously used Docker images.

* Update GitHub Actions.

# viash_project_template 0.1.0

First release of the project template repository.

Components:

* `src/demo/remove_comments`: A Bash-based component to remove all lines starting with a comment character `#`.

* `src/demo/take_column`: A Python-based component to extract a specific column from a TSV file.

* `src/demo/combine_columns`: An R-based component to combine multiple TSV files into one.

Pipelines:

* `workflows/demo_pipeline/main.nf`: A demo pipeline which uses abovementioned components.
