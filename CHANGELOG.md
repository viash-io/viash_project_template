# viash_project_template 0.4.0

* Update to Viash 0.9.0-RC6.

* Update CI to viash-actions@v6.

* Add unit tests to all components.

* Simplify workflow to not use external dependencies.


# viash_project_template 0.3.0

* Update to Viash 0.8.2

* `demo_pipeline` is now built from `src/workflow`.

* State management overhaul.

* Use of helper functions (dependencies) from [`vsh_utils`](https://viash-hub.com/data-intuitive/vsh_utils).


# viash_project_template 0.2.0

* Update to Viash 0.7.1.

* Replace 'underscore' (like `viash_build`) commands with equivalent 'ns' command (`viash ns build`).

* Use slim versions of the previously used Docker images.

* Update GitHub Actions.


# viash_project_template 0.1.0

First release of the project template repository.

Components:

* `remove_comments`: A Bash-based component to remove all lines starting with a comment character `#`.

* `take_column`: A Python-based component to extract a specific column from a TSV file.

* `combine_columns`: An R-based component to combine multiple TSV files into one.

Pipelines:

* `workflow`: A demo pipeline which uses abovementioned components.
