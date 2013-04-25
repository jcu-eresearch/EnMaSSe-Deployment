#!/bin/bash
clear

virtualenv-2.7 --no-site-packages venv
venv/bin/easy_install zc.buildout distribute

# Setup the lxml egg before calling buildout (lxml has problems)
mkdir ./eggs
cp -r lxml-binaries/lxml ./eggs/
cp lxml-binaries/linux/lxml-3.1.0-py2.7.egg-info ./eggs/

venv/bin/buildout
