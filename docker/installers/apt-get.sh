#!/usr/bin/env bash

set -e

apt-get update

apt-get install -y \
	gnupg2=2.1.11-6ubuntu2.1 \
	gnupg-agent=2.1.11-6ubuntu2.1 \
	git

apt-get clean

rm -rf \
	/var/lib/apt/lists/* \
	/tmp/* \
	/var/tmp/*