#!/bin/bash

export PIP_ONLY_BINARY=cmake

source "$HOME/.cargo/env"

pypi-mirror download -d packages -r requirements.txt
pypi-mirror create -d packages -m simple
