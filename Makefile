name := pypi_mirror

.DEFAULT_GOAL := all

## all target
.PHONY: all
all: build

.PHONY: build
build:
	docker build --tag 172.16.16.1:5000/pypi_mirror:latest .

.PHONY: push
push:
	docker push 172.16.16.1:5000/pypi_mirror:latest

.PHONY: run
run:
	docker run -it --rm --name pypi_mirror \
		-v /opt/devstack/packages:/data/packages \
		-v /opt/pypi_mirror/pip_dir:/root/.cache/pip \
		-v /opt/pypi_mirror/tmp_dir:/tmp \
		-v ./mirror.sh:/data/mirror.sh:ro \
		-v ./requirements.txt:/data/requirements.txt:ro \
		-w /data \
		172.16.16.1:5000/pypi_mirror:latest \
		/bin/bash
