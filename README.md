# TibSchol Data Model

In this repository we keep the definitions of the overall TibSchol data model.

NB The TEI customization and RNG Schema are part of the TibSchol Curation repository.

## How to build the html output

The necessary steps to build a html and docx documentation of this model is found in the Dockerfile in this directory. In order to build it just run

```
> podman image build . --tag tibscholmodel
```

NB If you use docker, just replace the `podman` command with `docker`.


