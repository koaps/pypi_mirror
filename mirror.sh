#!/bin/bash

pypi-mirror download -d packages -r requirements.txt
pypi-mirror create -d packages -m simple
