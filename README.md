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

  
  script & config --- viash_build --> docker_image & executable
  docker_image -.-> executable & nextflow
  viash_build --> nextflow

  nextflow --dependency--> nextflow

  subgraph compute [Compute environment]
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
     Already-up-to-date
    Launching `https://github.com/viash-io/viash_project_template` [kickass_wescoff] DSL2 - revision: 5971837633 [build/main]
    [5c/8aaf68] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file2)
    [73/4b02d0] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file1)
    [1d/68933b] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file2)
    [5f/3cf8f1] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file1)
    [88/61f733] Submitted process > workflow:run_wf:combine_columns:processWf:combine_columns_process (combined)
    [97/67bc9f] Submitted process > workflow:publishStatesSimpleWf:publishStatesProc (combined)

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

    .
    ├── CHANGELOG.md
    ├── LICENSE.md
    ├── main.nf
    ├── nextflow.config
    ├── output
    │   ├── combined.workflow.output.tsv
    │   └── combined.workflow.state.yaml
    ├── README.md
    ├── README.qmd
    ├── README.rmarkdown
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
    ├── target
    │   ├── executable
    │   │   └── template
    │   │       ├── combine_columns
    │   │       │   └── combine_columns
    │   │       ├── remove_comments
    │   │       │   └── remove_comments
    │   │       └── take_column
    │   │           └── take_column
    │   └── nextflow
    │       └── template
    │           ├── combine_columns
    │           │   ├── main.nf
    │           │   └── nextflow.config
    │           ├── remove_comments
    │           │   ├── main.nf
    │           │   └── nextflow.config
    │           ├── take_column
    │           │   ├── main.nf
    │           │   └── nextflow.config
    │           └── workflow
    │               ├── main.nf
    │               └── nextflow.config
    ├── _viash.yaml
    └── work
        ├── 06
        │   └── a3006b168d22b3e83969c4898749a5
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/a7/c679ecc6ae8733335239af4e0d0dc9/file1.remove_comments.output.tsv
        ├── 09
        │   ├── b58e7035067d290c594b6d72f7821a
        │   │   ├── file1.take_column.output
        │   │   └── _viash_par
        │   │       └── input_1
        │   │           └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/a2/b3564fe776cf19c0edabc54d26c184/file1.remove_comments.output.tsv
        │   └── b90d7e2c6d52171f88bd620e05369e
        │       ├── run.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── run.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/c7/7afec45f9f4b9db690a4cba6a00670/run.remove_comments.output.tsv
        ├── 1d
        │   └── 68933ba6483502335f9a3eed283430
        │       ├── file2.take_column.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/5c/8aaf680dcd64ff8c8a151deacb81f9/file2.remove_comments.output.tsv
        ├── 21
        │   ├── b4d65aee46652cd8ce8bf1f41fcab3
        │   │   ├── file2.take_column.output
        │   │   └── _viash_par
        │   │       └── input_1
        │   │           └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/98/8ee4c9834771af344d7d0e9171076c/file2.remove_comments.output.tsv
        │   └── e860a6cc83493cc30d3a143b52720f
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/5d/0cbbd10d655da98fd97096af3cab88/file1.remove_comments.output.tsv
        ├── 26
        │   └── aad43981204229e5a96afca102cc0e
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/61/8904a30b52eb2d75b1c0f79560c4e2/file1.remove_comments.output.tsv
        ├── 2d
        │   └── 02ee3975fea97f2880ccd2810419a8
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── 30
        │   └── 943cd9dca2d52f064c83a077c0030b
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── 31
        │   └── 10dec555246c7a567917e7636b4dd8
        │       ├── combined.workflow.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/42/fc43ba6329aefa58093c2398bdad50/combined.combine_columns.output
        │       ├── combined.workflow.state.yaml
        │       └── _inputfile1
        │           └── combined.combine_columns.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/42/fc43ba6329aefa58093c2398bdad50/combined.combine_columns.output
        ├── 32
        │   └── 66e33b9c2e5d2dfe6cf197db7d4434
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/a2/364f5e24ac876c1c623e5108715c25/file1.remove_comments.output.tsv
        ├── 34
        │   └── 01b46f7b0e2e645ab666e5018eabae
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/30/943cd9dca2d52f064c83a077c0030b/file2.remove_comments.output.tsv
        ├── 35
        │   └── ff74feb03f9d5cf31be060f27b83ea
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/2d/02ee3975fea97f2880ccd2810419a8/file1.remove_comments.output.tsv
        ├── 3a
        │   └── fc6d6918dc9e5fbe5ac206866c07d7
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/51/c6c6f3fdde45320e405d179f99d312/file1.remove_comments.output.tsv
        ├── 42
        │   └── fc43ba6329aefa58093c2398bdad50
        │       ├── combined.combine_columns.output
        │       └── _viash_par
        │           └── input_1
        │               └── run.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/09/b90d7e2c6d52171f88bd620e05369e/run.take_column.output
        ├── 48
        │   └── 8b8abb853b5655faca3e83b6cb87f4
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/ba/8a0be6177948bbd73bedbcd8139bf8/file2.remove_comments.output.tsv
        ├── 4f
        │   └── 99d95392847652f65a764f0001159d
        │       ├── combined.combine_columns.output
        │       └── _viash_par
        │           ├── input_1
        │           │   └── file1.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/32/66e33b9c2e5d2dfe6cf197db7d4434/file1.take_column.output
        │           └── input_2
        │               └── file2.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/21/b4d65aee46652cd8ce8bf1f41fcab3/file2.take_column.output
        ├── 51
        │   ├── 95b87d7f7d399dea480329c3b38517
        │   │   ├── file2.take_column.output
        │   │   └── _viash_par
        │   │       └── input_1
        │   │           └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/9a/ad3aa863beece2788e3d92be2a6f73/file2.remove_comments.output.tsv
        │   └── c6c6f3fdde45320e405d179f99d312
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── 55
        │   └── e11e0944472b95b72185b0df1220fb
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/e6/35d4d3da9b59d4067d39160a4bfc29/file1.remove_comments.output.tsv
        ├── 5b
        │   └── d0afe02848b88c0eddf6d916cf154e
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/ff/92e90fad70cda6a2321828f66f6e20/file1.remove_comments.output.tsv
        ├── 5c
        │   └── 8aaf680dcd64ff8c8a151deacb81f9
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── 5d
        │   └── 0cbbd10d655da98fd97096af3cab88
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── 5f
        │   └── 3cf8f1789d40db134908e559e153a6
        │       ├── file1.take_column.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/73/4b02d03f28c6302681d2ae734111a5/file1.remove_comments.output.tsv
        ├── 61
        │   └── 8904a30b52eb2d75b1c0f79560c4e2
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── 62
        │   └── de6211e1d7789e99eb61cb441791a5
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/86/d861b82819ce1c8641a99dea5bc06d/file2.remove_comments.output.tsv
        ├── 63
        │   └── 8f05732c75eb656755c96bae17b264
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── 65
        │   ├── 74f3824fa5c47fe39f4a7afa513ba3
        │   │   ├── file2.remove_comments.output.tsv
        │   │   └── _viash_par
        │   │       └── input_1
        │   │           └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        │   └── 7777c077e4babe34679772778fb93b
        │       ├── combined.workflow.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/f1/ce34e28b79f169d55de4b82ad995b9/combined.combine_columns.output
        │       ├── combined.workflow.state.yaml
        │       └── _inputfile1
        │           └── combined.combine_columns.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/f1/ce34e28b79f169d55de4b82ad995b9/combined.combine_columns.output
        ├── 66
        │   └── 231e28ffbaa4e2a1453ea9bc16a4cd
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/65/74f3824fa5c47fe39f4a7afa513ba3/file2.remove_comments.output.tsv
        ├── 6e
        │   └── 6e14906d52ce474625898954ecdc23
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/63/8f05732c75eb656755c96bae17b264/file2.remove_comments.output.tsv
        ├── 73
        │   └── 4b02d03f28c6302681d2ae734111a5
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── 76
        │   └── 7bf19fa673c71d66ad67b332ff688d
        │       ├── combined.workflow.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/4f/99d95392847652f65a764f0001159d/combined.combine_columns.output
        │       ├── combined.workflow.state.yaml
        │       └── _inputfile1
        │           └── combined.combine_columns.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/4f/99d95392847652f65a764f0001159d/combined.combine_columns.output
        ├── 7d
        │   └── aa34e2647eacc36dd144b6a643283f
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── 83
        │   └── 7735332945bbaf93840edf9909b46f
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/7d/aa34e2647eacc36dd144b6a643283f/file2.remove_comments.output.tsv
        ├── 84
        │   └── 015399352b2ab968207ebedacae56a
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/8f/850c4d4b5974c7f0cae9c5168b2ae8/file2.remove_comments.output.tsv
        ├── 86
        │   └── d861b82819ce1c8641a99dea5bc06d
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── 88
        │   └── 61f733186d443467b3efe1cd3b883a
        │       ├── combined.combine_columns.output.tsv
        │       └── _viash_par
        │           ├── input_1
        │           │   └── file2.take_column.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/1d/68933ba6483502335f9a3eed283430/file2.take_column.output.tsv
        │           └── input_2
        │               └── file1.take_column.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/5f/3cf8f1789d40db134908e559e153a6/file1.take_column.output.tsv
        ├── 8c
        │   └── 0ed6763b13d090cc5ee720d27ef5cd
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/bf/ab6cbd0018d747facdfd11a71a2c25/file2.remove_comments.output.tsv
        ├── 8f
        │   └── 850c4d4b5974c7f0cae9c5168b2ae8
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── 91
        │   └── 4476a4387a1901b58422821cdb8fa7
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/c2/de1bc7b847fe9c8633b88062cb9340/file1.remove_comments.output.tsv
        ├── 97
        │   ├── 67bc9ff22c2f1fadc730d142de61bf
        │   │   ├── combined.workflow.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/88/61f733186d443467b3efe1cd3b883a/combined.combine_columns.output.tsv
        │   │   ├── combined.workflow.state.yaml
        │   │   └── _inputfile1
        │   │       └── combined.combine_columns.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/88/61f733186d443467b3efe1cd3b883a/combined.combine_columns.output.tsv
        │   └── 6daabf50e09b9d2da9f86acf90d123
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/f3/c77cae694e5a7a8fe3f0d9da6e7ea7/file1.remove_comments.output.tsv
        ├── 98
        │   ├── 4b5da43710156221a5cc0f6deb76ad
        │   │   ├── file2.remove_comments.output.tsv
        │   │   └── _viash_par
        │   │       └── input_1
        │   │           └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        │   └── 8ee4c9834771af344d7d0e9171076c
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── 9a
        │   └── ad3aa863beece2788e3d92be2a6f73
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── a2
        │   ├── 364f5e24ac876c1c623e5108715c25
        │   │   ├── file1.remove_comments.output.tsv
        │   │   └── _viash_par
        │   │       └── input_1
        │   │           └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        │   └── b3564fe776cf19c0edabc54d26c184
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── a4
        │   └── a74edbfaa812574d80fd75b09b83b1
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── a7
        │   ├── 1be5d7138644b119c619b6ac5c29ff
        │   │   ├── combined.combine_columns.output
        │   │   └── _viash_par
        │   │       ├── input_1
        │   │       │   └── file2.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/51/95b87d7f7d399dea480329c3b38517/file2.take_column.output
        │   │       └── input_2
        │   │           └── file1.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/3a/fc6d6918dc9e5fbe5ac206866c07d7/file1.take_column.output
        │   └── c679ecc6ae8733335239af4e0d0dc9
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── ab
        │   └── 7f98ad9acc62e80c52a003cebd92c4
        │       ├── combined.workflow.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/b5/b331c8086ab5774c54627aba58c78f/combined.combine_columns.output
        │       ├── combined.workflow.state.yaml
        │       └── _inputfile1
        │           └── combined.combine_columns.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/b5/b331c8086ab5774c54627aba58c78f/combined.combine_columns.output
        ├── af
        │   └── 5d914f45c9d88927d3b5119c1b53bc
        │       ├── combined.workflow.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/b6/db73ceff64f21c975a4919a1650f14/combined.combine_columns.output
        │       ├── combined.workflow.state.yaml
        │       └── _inputfile1
        │           └── combined.combine_columns.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/b6/db73ceff64f21c975a4919a1650f14/combined.combine_columns.output
        ├── b0
        │   └── e9494bca7fe10c457cca714d48373c
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/98/4b5da43710156221a5cc0f6deb76ad/file2.remove_comments.output.tsv
        ├── b5
        │   └── b331c8086ab5774c54627aba58c78f
        │       ├── combined.combine_columns.output
        │       └── _viash_par
        │           ├── input_1
        │           │   └── file2.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/b0/e9494bca7fe10c457cca714d48373c/file2.take_column.output
        │           └── input_2
        │               └── file1.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/5b/d0afe02848b88c0eddf6d916cf154e/file1.take_column.output
        ├── b6
        │   └── db73ceff64f21c975a4919a1650f14
        │       ├── combined.combine_columns.output
        │       └── _viash_par
        │           ├── input_1
        │           │   └── file1.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/97/6daabf50e09b9d2da9f86acf90d123/file1.take_column.output
        │           └── input_2
        │               └── file2.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/83/7735332945bbaf93840edf9909b46f/file2.take_column.output
        ├── ba
        │   └── 8a0be6177948bbd73bedbcd8139bf8
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── bc
        │   └── ecc4ac2166ddce2d5f5f99750167ab
        │       ├── combined.combine_columns.output
        │       └── _viash_par
        │           ├── input_1
        │           │   └── file1.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/21/e860a6cc83493cc30d3a143b52720f/file1.take_column.output
        │           └── input_2
        │               └── file2.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/48/8b8abb853b5655faca3e83b6cb87f4/file2.take_column.output
        ├── bf
        │   └── ab6cbd0018d747facdfd11a71a2c25
        │       ├── file2.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file2.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file2.tsv
        ├── c2
        │   └── de1bc7b847fe9c8633b88062cb9340
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── c7
        │   └── 7afec45f9f4b9db690a4cba6a00670
        │       └── run.remove_comments.output.tsv
        ├── d4
        │   └── 84823059b693efb2cc0eee9cbb7e3f
        │       ├── file1.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file1.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/da/fa0bfc9ac6fdd94a3d3c3d1a501e2d/file1.remove_comments.output.tsv
        ├── d7
        │   └── 49029eb5446a27efc5479b06db24e2
        │       ├── combined.workflow.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/a7/1be5d7138644b119c619b6ac5c29ff/combined.combine_columns.output
        │       ├── combined.workflow.state.yaml
        │       └── _inputfile1
        │           └── combined.combine_columns.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/a7/1be5d7138644b119c619b6ac5c29ff/combined.combine_columns.output
        ├── d8
        │   └── 368c2fea0ec08d02507cf67a00bbdd
        │       └── _viash_par
        │           ├── input_1
        │           │   └── file2.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/62/de6211e1d7789e99eb61cb441791a5/file2.take_column.output
        │           └── input_2
        │               └── file1.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/09/b58e7035067d290c594b6d72f7821a/file1.take_column.output
        ├── da
        │   └── fa0bfc9ac6fdd94a3d3c3d1a501e2d
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── e6
        │   └── 35d4d3da9b59d4067d39160a4bfc29
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        ├── f1
        │   └── ce34e28b79f169d55de4b82ad995b9
        │       ├── combined.combine_columns.output
        │       └── _viash_par
        │           ├── input_1
        │           │   └── file1.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/26/aad43981204229e5a96afca102cc0e/file1.take_column.output
        │           └── input_2
        │               └── file2.take_column.output -> /home/rcannood/workspace/viash-io/viash_project_template/work/84/015399352b2ab968207ebedacae56a/file2.take_column.output
        ├── f2
        │   └── 48fb9e82c07932a4f8541e709f3aad
        │       ├── file2.take_column.output
        │       └── _viash_par
        │           └── input_1
        │               └── file2.remove_comments.output.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/work/a4/a74edbfaa812574d80fd75b09b83b1/file2.remove_comments.output.tsv
        ├── f3
        │   └── c77cae694e5a7a8fe3f0d9da6e7ea7
        │       ├── file1.remove_comments.output.tsv
        │       └── _viash_par
        │           └── input_1
        │               └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv
        └── ff
            └── 92e90fad70cda6a2321828f66f6e20
                ├── file1.remove_comments.output.tsv
                └── _viash_par
                    └── input_1
                        └── file1.tsv -> /home/rcannood/workspace/viash-io/viash_project_template/resources_test/file1.tsv

    293 directories, 188 files

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

    Exporting workflow (template) =nextflow=> target/nextflow/template/workflow
    Exporting take_column (template) =nextflow=> target/nextflow/template/take_column
    Exporting combine_columns (template) =executable=> target/executable/template/combine_columns
    Exporting take_column (template) =executable=> target/executable/template/take_column
    Exporting remove_comments (template) =nextflow=> target/nextflow/template/remove_comments
    Exporting combine_columns (template) =nextflow=> target/nextflow/template/combine_columns
    Exporting remove_comments (template) =executable=> target/executable/template/remove_comments
    [notice] Building container 'ghcr.io/viash-io/project_template/template/take_column:dev' with Dockerfile
    [notice] Building container 'ghcr.io/viash-io/project_template/template/combine_columns:dev' with Dockerfile
    [notice] Building container 'ghcr.io/viash-io/project_template/template/remove_comments:dev' with Dockerfile
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
    Launching `target/nextflow/template/workflow/main.nf` [modest_noyce] DSL2 - revision: 43ac230bc0
    [93/914f3c] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file1)
    [6e/23e430] Submitted process > workflow:run_wf:remove_comments:processWf:remove_comments_process (file2)
    [7d/7c9e5f] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file2)
    [91/8c0ac0] Submitted process > workflow:run_wf:take_column:processWf:take_column_process (file1)
    [df/b8f210] Submitted process > workflow:run_wf:combine_columns:processWf:combine_columns_process (combined)
    [3b/03eccd] Submitted process > workflow:publishStatesSimpleWf:publishStatesProc (combined)

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
