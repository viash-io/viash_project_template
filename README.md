# Viash project template


<!-- README.md is generated from README.qmd using quarto render. Please edit that file -->

This repository is a template for setting up a new Viash project, and is
part of the [Quickstart](https://viash.io/quickstart) tutorial to learn
how to get started with this repository.

## What is Viash?

**Viash** is your go-to script wrapper for building data pipelines from
modular software components. All you need is your trusty script and a
metadata file to embark on this journey.

Check out some of Viash’s key features:

- Code in your [favorite scripting
  language](./guide/component/create-component.html). Mix and match
  scripting between multiple components to suit your needs. Viash
  supports a wide range of languages, including Bash, Python, R, Scala,
  JS, and C#.

- A **custom Docker container** is auto-generated based on the
  dependencies you’ve outlined in your metadata, meaning you don’t need
  to be a Docker expert.

- Viash also generates a **Nextflow module** from your script, so no
  need to be a Nextflow guru either.

- Effortlessly combine Nextflow modules to design and run scalable,
  reproducible data pipelines.

- Test every component on your local workstation using the convenient
  built-in development kit.

``` mermaid
graph LR
  subgraph component [Viash component]
    subgraph script [Script]
      rlang[R script]
      python[Python script]
      bash[Bash script]
      scriptetc[...]
    end

    config[Viash config]
  end

  viash_build[Viash build]

  docker_image[Docker image]
  executable[Executable]
  nextflow[Nextflow workflow]

  
  component --- viash_build --> executable & docker_image & nextflow
  docker_image -.-> executable & nextflow


  nextflow --dependency--> nextflow

  subgraph compute [Compute environment]
    direction LR
    local[Local execution]
    awsbatch[AWS Batch]
    googlebatch[Google Cloud Batch]
    hpc[HPC]
    infraetc[...]
  end

  nextflow --> compute
```

## Requirements

This guide assumes you’ve already installed
[Viash](https://viash.io/installation),
[Docker](https://docs.docker.com/engine/install). and
[Nextflow](https://www.nextflow.io/index.html#GetStarted).

## Structure of this template project

To get up and running fast, we provide a [template
project](https://github.com/viash-io/viash_project_template) for you to
use. It contains four components from the same package as well, which
are combined into a Nextflow pipeline as follows:

``` mermaid
graph TD
   input1(file1.tsv) --> B1[/remove_comments/] --> C1[/take_column/] --> Y
   input2(file2.tsv)--> B2[/remove_comments/] --> C2[/take_column/] --> Y
   Y[combine] --> D[/combine_columns/]
   D --> output(output.tsv)
```

This pipeline takes one or more TSV files as input and stores its output
in an output folder.

## Example usage

To run the pipeline, first create example input files.

Contents of `resources_test/file1.tsv`:

    # this is a header      
    # this is also a header     
    one 0.11    123
    two 0.23    456
    three   0.35    789
    four    0.47    123

Contents of `resources_test/file2.tsv`:

    # this is not a header
    # just kidding yes it is
    eins    0.111   234
    zwei    0.222   234
    drei    0.333   123
    vier    0.444   123

Finally, we also need to create a `params.yaml` file to specify the
input files for the pipeline:

Contents of `resources_test/params.yaml`:

    param_list:
      - id: file1
        input: resources_test/file1.tsv
      - id: file2
        input: resources_test/file2.tsv

Now run the pipeline:

``` bash
nextflow run viash-io/viash_project_template \
  -main-script target/nextflow/template/workflow/main.nf \
  -r build/main \
  -latest \
  -profile docker \
  -params-file resources_test/params.yaml \
  --publish_dir output
```

<details>
<summary>
Output
</summary>

    [33mNextflow 24.04.3 is available - Please consider updating your version to it(B[m
    N E X T F L O W  ~  version 23.10.0
    Pulling viash-io/viash_project_template ...
     Fast-forward
    Launching `https://github.com/viash-io/viash_project_template` [golden_kalman] DSL2 - revision: d02c1ce592 [build/main]
    [fd/a3b85a] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file1)
    [77/b5f28c] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file2)
    [ab/cd4194] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file2)
    [66/ec3197] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file1)
    [f8/f6997e] Submitted process > workflow:run_wf:combine_columns:processWf:combine_columns_process (combined)
    [74/1f9dde] Submitted process > workflow:publishStatesSimpleWf:publishStatesProc (combined)

</details>

If you have a [Seqera Cloud](https://cloud.seqera.io) compute
environment already set up, you can also launch the workflow there:

``` bash
cat > params.yaml <<EOF
param_list:
  - id: file1
    input: s3://my-bucket/file1.tsv
  - id: file2
    input: s3://my-bucket/file2.tsv
publish_dir: s3://my-bucket/output
EOF

tw launch viash-io/viash_project_template \
  --main-script target/nextflow/template/workflow/main.nf \
  --revision build/main \
  --pull-latest \
  --workspace 123456789 \
  --compute-env ABCDEFGHIJKLMNOP \
  --params-file params.yaml
```

## Extending this template

This template is a great starting point for building your own Viash
project. Here’s how you can extend it.

### Step 1: Get the template

First create a new repository by clicking the “Use this template”
button. If you can’t see the “Use this template” button, log into GitHub
first.

Next, clone the repository using the following command.

``` bash
git clone https://github.com/youruser/my_first_pipeline.git && cd my_first_pipeline
```

Your new repository should contain the following files:

``` bash
tree my_first_pipeline
```

<details>
<summary>
Output
</summary>

    .
    ├── CHANGELOG.md
    ├── LICENSE.md
    ├── main.nf
    ├── nextflow.config
    ├── README.md
    ├── README.qmd
    ├── resources_test
    │   ├── file1.tsv
    │   ├── file2.tsv
    │   └── params.yaml
    ├── src
    │   └── template
    │       ├── combine_columns
    │       │   ├── config.vsh.yaml
    │       │   ├── script.R
    │       │   └── test.R
    │       ├── remove_comments
    │       │   ├── config.vsh.yaml
    │       │   ├── script.sh
    │       │   └── test.sh
    │       ├── take_column
    │       │   ├── config.vsh.yaml
    │       │   ├── script.py
    │       │   └── test.py
    │       └── workflow
    │           ├── config.vsh.yaml
    │           └── main.nf
    └── _viash.yaml

</details>

### Step 2: Build the Viash components

With Viash you can turn the components in `src/` into Dockerized
Nextflow modules by running:

``` bash
viash ns build --setup cachedbuild --parallel
```

<details>
<summary>
Output
</summary>

    Exporting take_column (template) =executable=> target/executable/template/take_column
    Exporting remove_comments (template) =executable=> target/executable/template/remove_comments
    Exporting workflow (template) =nextflow=> target/nextflow/template/workflow
    Exporting combine_columns (template) =executable=> target/executable/template/combine_columns
    Exporting take_column (template) =nextflow=> target/nextflow/template/take_column
    Exporting remove_comments (template) =nextflow=> target/nextflow/template/remove_comments
    Exporting combine_columns (template) =nextflow=> target/nextflow/template/combine_columns
    [notice] Building container 'ghcr.io/viash-io/project_template/template/combine_columns:dev' with Dockerfile
    [notice] Building container 'ghcr.io/viash-io/project_template/template/remove_comments:dev' with Dockerfile
    [notice] Building container 'ghcr.io/viash-io/project_template/template/take_column:dev' with Dockerfile
    All 7 configs built successfully

</details>

This command not only transforms the Viash components in `src/` to
Nextflow modules but it also builds the containers when appropriate
(starting from the Docker cache when available using the `cachedbuild`
argument). Once everything is built, a new **target** directory has been
created containing the executables and modules grouped per platform:

``` bash
tree target
```

<details>
<summary>
Output
</summary>

    target
    ├── executable
    │   └── template
    │       ├── combine_columns
    │       │   └── combine_columns
    │       ├── remove_comments
    │       │   └── remove_comments
    │       └── take_column
    │           └── take_column
    └── nextflow
        └── template
            ├── combine_columns
            │   ├── main.nf
            │   └── nextflow.config
            ├── remove_comments
            │   ├── main.nf
            │   └── nextflow.config
            ├── take_column
            │   ├── main.nf
            │   └── nextflow.config
            └── workflow
                ├── main.nf
                └── nextflow.config

    12 directories, 11 files

</details>

### Step 3: Run the pipeline

You can now run the locally built pipeline using the following command:

``` bash
nextflow run . \
  -main-script target/nextflow/template/workflow/main.nf \
  -profile docker \
  -params-file resources_test/params.yaml \
  --publish_dir output
```

<details>
<summary>
Output
</summary>

    [33mNextflow 24.04.3 is available - Please consider updating your version to it(B[m
    N E X T F L O W  ~  version 23.10.0
    Launching `target/nextflow/template/workflow/main.nf` [distracted_williams] DSL2 - revision: bbc6ad6ba4
    [5f/28124e] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file1)
    [fa/45bf29] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file2)
    [e0/cf7ba0] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file1)
    [1d/d36294] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file2)
    [3f/d80ba4] Submitted process > workflow:run_wf:combine_columns:processWf:combine_columns_process (combined)
    [43/7008a3] Submitted process > workflow:publishStatesSimpleWf:publishStatesProc (combined)

</details>

This will run the different stages of the workflow , with the final
result result being stored in a file named
**run.combine_columns.output** in the output directory `output`:

``` bash
cat output/combined.workflow.output.tsv
```

<details>
<summary>
Output
</summary>

    "1" 0.11    0.111
    "2" 0.23    0.222
    "3" 0.35    0.333
    "4" 0.47    0.444

</details>

## What’s next?

Congratulations, you’ve reached the end of this quickstart tutorial, and
we’re excited for you to delve deeper into the world of Viash! Our
comprehensive [guide](https://viash.io/guide) and [reference
documentation](https://viash.io/reference) is here to help you explore
various topics, such as:

- [Creating a Viash component and converting it into a standalone
  executable](https://viash.io/guide/component/create-component)
- [Ensuring reproducibility and designing customised Docker
  images](https://viash.io/guide/component/add-dependencies)
- [Ensuring code reliability with unit testing for
  Viash](https://viash.io/guide/component/unit-testing)
- [Streamlining your workflow by performing batch operations on Viash
  projects](https://viash.io/guide/project/batch-processing)
- [Building Nextflow pipelines using Viash
  components](https://viash.io/guide/nextflow_vdsl3)

So, get ready to enhance your skills and create outstanding solutions
with Viash!
