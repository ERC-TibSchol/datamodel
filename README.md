# TibSchol Data Model

In this repository we keep the definitions of the overall TibSchol data model.

Here is a [visual sketch of the model](https://github.com/ERC-TibSchol/datamodel/blob/master/TibSchol_datamodel_sketch.pdf).

NB The TEI customization and RNG Schema are part of the TibSchol Curation repository (private).

## How to build the html output

The necessary steps to build a html and docx documentation of this model is found in the Dockerfile in this directory. In order to build it just run

```
> podman image build . --tag acdh-ch-tibschol-datamodel
> podman run -dt --name acdh-ch-tibschol-datamodel localhost/acdh-ch-tibschol-datamodel:latest /bin/bash
> podman container cp acdh-ch-tibschol-datamodel:/tmp/index.html .
> podman container cp acdh-ch-tibschol-datamodel:/tmp/index.docx .
> podman container cp acdh-ch-tibschol-datamodel:/tmp/index.svg .

# clean up after yourself

> podman stop --latest 
> podman container rm --latest 
```

Or, more simple:

```
chmod u+x rebuild.sh
./rebuild.sh
```

NB If you use docker, just replace the `podman` command with `docker`.


