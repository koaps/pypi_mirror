name := pypi_mirror

.DEFAULT_GOAL := all

## all target
.PHONY: all
all: build push cleanup run

.PHONY: build
build:
	docker build --tag 172.16.16.1:5000/${name}:latest .

.PHONY: push
push:
	docker push 172.16.16.1:5000/${name}:latest

.PHONY: run
run:
	docker run -d --name ${name} \
		-v /opt/devstack/packages:/data/packages \
		-v /opt/pypi_mirror/pip_dir:/root/.cache/pip \
		-v /opt/pypi_mirror/tmp_dir:/tmp \
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
	docker restart pypi_server

.PHONY: restart
restart:
	docker restart ${name}

.PHONY: shell
shell:
	docker exec -it ${name} /bin/bash
