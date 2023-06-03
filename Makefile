name := pypi_mirror

.DEFAULT_GOAL := all

## all target
.PHONY: all
all: build

.PHONY: build
build:
	docker build --tag 172.16.16.1:5000/pypi_mirror:latest .
