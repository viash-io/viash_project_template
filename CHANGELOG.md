# viash_project_template 0.3.1

## MINOR CHANGES

* Bump Viash version to 0.9.4
* Fix unit test for `combine_columns`

# viash_project_template 0.3.0

## MAJOR CHANGES

* Update to Viash 0.9.0-RC6.

* Update CI to viash-actions@v6.

* Add unit tests to all components.

* Simplify workflow to not use external dependencies.


# viash_project_template 0.2.2

## BUG FIXES

* Install `bit64` in `r2u` images.

* Fix workflow ID passing in workflow.


# viash_project_template 0.2.2

## BUG FIXES

* Install `procps` in `python:3.10-slim` images.


# viash_project_template 0.2.1

## MINOR CHANGES

* Updated to Viash 0.8.4.

# viash_project_template 0.2.0

## MAJOR CHANGES

* Update to Viash 0.7.1 (PR #1).

* Update to Viash 0.8.2 (PR #10).

* Replace 'underscore' (like `viash_build`) commands with equivalent 'ns' command (`viash ns build`).

* State management overhaul.

* Use of helper functions (dependencies) from [`vsh_utils`](https://viash-hub.com/data-intuitive/vsh_utils).

* `demo_pipeline` is now built from `src/workflow`.

## MINOR CHANGES

* Update GitHub Actions (PR #8).

* Use slim versions of the previously used Docker images.


# viash_project_template 0.1.0

First release of the project template repository.

Components:

* `remove_comments`: A Bash-based component to remove all lines starting with a comment character `#`.

* `take_column`: A Python-based component to extract a specific column from a TSV file.

* `combine_columns`: An R-based component to combine multiple TSV files into one.

Pipelines:

* `workflow`: A demo pipeline which uses abovementioned components.
