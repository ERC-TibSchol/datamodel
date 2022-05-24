podman image build . --tag tibscholmodel
podman run -dt --name tibscholmodel localhost/tibscholmodel:latest /bin/bash
podman container cp tibscholmodel:/tmp/index.html .
podman container cp tibscholmodel:/tmp/index.docx .
podman container cp tibscholmodel:/tmp/index.svg .

# clean up after yourself

podman stop tibscholmodel
podman container rm tibscholmodel
