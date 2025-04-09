name := pypi_mirror

dev_dir := /home/devstack
pkg_dir := ${dev_dir}/packages

.DEFAULT_GOAL := all

## all target
.PHONY: all
all: build cleanup run

.PHONY: build
build:
	docker build --tag 172.16.16.1:5000/${name}:latest .

.PHONY: push
push:
	docker push 172.16.16.1:5000/${name}:latest

.PHONY: run
run:
	docker run -d --name ${name} \
		-v ${pkg_dir}:/data/packages \
		-v ${dev_dir}/${name}/pip_dir:/root/.cache/pip \
		-v ${dev_dir}/${name}/tmp_dir:/tmp \
		-v ./mirror.sh:/data/mirror.sh:ro \
                -v ./requirements.txt:/data/requirements.txt:ro \
		-w /data \
		172.16.16.1:5000/${name}:latest

.PHONY: cleanup
cleanup:
	docker rm -f ${name}

.PHONY: mirror
mirror: restart
	docker exec -it -w /data ${name} ./mirror.sh
	docker restart ${name}

.PHONY: restart
restart:
	docker restart ${name}

.PHONY: shell
shell:
	docker exec -it ${name} /bin/bash
