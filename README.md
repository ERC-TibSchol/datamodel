# TibSchol Data Model

In this repository we keep the definitions of the overall data model for the database of the project  <i>The Dawn of Tibetan Buddhist Scholasticism (11th-13th c.)</i> (TibSchol). Cf. <https://www.oeaw.ac.at/ikga/tibschol> for more information.

This project has received funding from the European Research Council (ERC) under the European Union's Horizon 2020 research and innovation programme (grant agreement No. 101001002). See <https://cordis.europa.eu/project/id/101001002>.

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


