Viash project template
================

<!-- README.md is generated from README.qmd using quarto render. Please edit that file -->
<p align="center">
<a href="https://viash.io/">
<img alt="viash" src="https://viash.io/logo/viash_large.svg" width="300">
</a>
</p>

This repository is a template for setting up a new
[Viash](https://viash.io) project.

## First development build

After forking it, run the following commands to build your first
development build of the pipeline.

Install Viash and Nextflow:

``` sh
# download viash in the bin folder
curl -fsSL get.viash.io | bash -s -- --tools false

# also download nextflow in the bin folder
cd bin
curl -s https://get.nextflow.io | bash
cd ..
```

Build Viash components

``` sh
bin/viash ns build --setup cachedbuild --parallel
```

    Exporting combine_columns (demo) =docker=> /home/rcannood/workspace/viash-io/viash_project_template/target/docker/demo/combine_columns
    Exporting take_column (demo) =docker=> /home/rcannood/workspace/viash-io/viash_project_template/target/docker/demo/take_column
    Exporting combine_columns (demo) =nextflow=> /home/rcannood/workspace/viash-io/viash_project_template/target/nextflow/demo/combine_columns
    Exporting remove_comments (demo) =docker=> /home/rcannood/workspace/viash-io/viash_project_template/target/docker/demo/remove_comments
    Exporting remove_comments (demo) =nextflow=> /home/rcannood/workspace/viash-io/viash_project_template/target/nextflow/demo/remove_comments
    Exporting take_column (demo) =nextflow=> /home/rcannood/workspace/viash-io/viash_project_template/target/nextflow/demo/take_column
    [notice] Building container 'ghcr.io/viash-io/viash_project_template/demo_combine_columns:dev' with Dockerfile
    [notice] Building container 'ghcr.io/viash-io/viash_project_template/demo_take_column:dev' with Dockerfile
    [notice] Building container 'ghcr.io/viash-io/viash_project_template/demo_remove_comments:dev' with Dockerfile
    All 6 configs built successfully

Run demo pipeline

``` sh
NXF_VER=22.10.4 bin/nextflow \
  run . \
  -main-script workflows/demo_pipeline/main.nf \
  -with-docker \
  --input resources_test/file*.tsv \
  --publishDir temp
```

    N E X T F L O W  ~  version 22.10.4
    Launching workflows/demo_pipeline/main.nf` [maniac_hodgkin] DSL2 - revision: c65d4e7bba
    [c4/65f41c] Submitted process > remove_comments:remove_comments_process (file1)
    [11/4e7d33] Submitted process > take_column:take_column_process (file1)
    [d3/002523] Submitted process > combine_columns:combine_columns_process (combined)
    Output: [combined, work/d3/00252389ac0bc69e1f2308c90791dc/combined.combine_columns.output]

## Contents of this template

    .
    ├── CHANGELOG.md
    ├── LICENSE.md
    ├── README.Rmd
    ├── README.md
    ├── _viash.yaml
    ├── bin
    │   ├── init
    │   ├── nextflow
    │   └── viash
    ├── main.nf
    ├── nextflow.config
    ├── resources_test
    │   ├── file1.tsv
    │   └── file2.tsv
    ├── src
    │   └── demo
    │       ├── combine_columns
    │       ├── remove_comments
    │       └── take_column
    └── workflows
        └── demo_pipeline
            ├── main.nf
            └── nextflow.config

## Customising the project

Generally, it’s a good idea to edit the `bin/init` by filling the
details of your own repository here. After making changes, rerun the
`bin/init` script.

If you want to start from a clean repository, remove the contents of the
`resources_test/`, `src/`, and `workflows/` directories.

## Unit testing

You can unit test all Viash components using the following command:

``` sh
bin/viash ns test --parallel
```

    The working directory for the namespace tests is /home/rcannood/workspace/viash_temp/viash_ns_test16160570057869067283
               namespace        functionality             platform            test_name exit_code duration               result
                    demo      combine_columns               docker                start                                        
                    demo      remove_comments               docker                start                                        
                    demo          take_column               docker                start                                        
                    demo      combine_columns               docker     build_executable         0        7              SUCCESS
                    demo      combine_columns               docker                tests        -1        0              MISSING
    no tests found
    ====================================================================
                    demo      remove_comments               docker     build_executable         0        5              SUCCESS
                    demo      remove_comments               docker              test.sh         0        4              SUCCESS
                    demo          take_column               docker     build_executable         0       12              SUCCESS
                    demo          take_column               docker                tests        -1        0              MISSING
    no tests found
    ====================================================================
    Not all configs built and tested successfully
      2/6 tests missing
      4/6 configs built and tested successfully

## Creating a release (manually)

The script below assumes you have a separate clone of this repository
specifically for building a release. To do so, switch to the release
branch, merge all changes from the main branch, build all components and
push the new release to Github and the containers to your Docker
registry of choice.

One time setup

``` sh
# clone repo
git clone git@github.com:myusername/demo_pipeline.git demo_pipeline_release
cd demo_pipeline_release

# switch to release branch
git checkout release

# allow publishing the target folder
sed -i '/^target.*/d' .gitignore
git add .gitignore
git commit -m "update gitignore for release"
```

For every build

``` sh
TAG=0.2.0

# merge latest changes in the release branch
rm -r target
git fetch origin
git merge origin/main

# build target folder and docker containers
bin/viash ns build --setup build --config_mod ".functionality.version := '$TAG'" --parallel

# run unit tests (ideally, these should all pass)
bin/viash ns test --config_mod ".functionality.version := '$TAG'" --parallel

# push docker containers to container registry
bin/viash ns build --config_mod ".functionality.version := '$TAG'" --setup push

# commit current code to release branch
git add target
git commit -m "Release $TAG"
git push

# create new tag
git tag -a "$TAG" -m "Release $TAG"
git push --tags
```

## Running a pipeline from release

When a release has been made, you can run the pipeline as follows:

``` sh
NXF_VER=22.10.4 bin/nextflow \
  run https://github.com/viash-io/viash_project_template \
  -main-script workflows/demo_pipeline/main.nf \
  -r 0.2.0 \
  -resume -latest \
  -with-docker \
  --input resources_test/file*.tsv \
  --publishDir temp
```

    Cannot find revision `0.2.0` -- Make sure that it exists in the remote repository `https://github.com/viash-io/viash_project_template`
    N E X T F L O W  ~  version 22.10.4
    Pulling viash-io/viash_project_template ...

Since all the components and containers are published on Github, this
pipeline should be 100% reproducible.

## Documentation

The Viash documentation is available online at
[`viash.io`](https://viash.io).

## License

Copyright (C) 2020 Data Intuitive

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along
with this program. If not, see <http://www.gnu.org/licenses/>.
