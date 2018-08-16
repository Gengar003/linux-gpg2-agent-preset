GPG2, `gpg-agent`, & preset passphrase on Ubuntu
=====

Purpose
==========

Given an ubuntu linux environment with GPG2 private keys, I want to start a `gpg-agent` and pre-load the passphrase for one of the keys so that _every_ attempt to sign with that key (by a tool that can use `gpg-agent`) avoids the passphrase prompt.

User Guide
==========

Build the System
-----

Just run `make build`.

You must have `docker` and `make` installed.

Run the System
-----

Just run `make run`.

This will start up the Docker image and _try_ to start up a `gpg-agent` with the passphrase to the key preset. It will also configure `git` to use that key to sign.

Feel free to follow either of the Approaches below to try to sign something.
This repository will be present (via a Docker bind-mount) in your home directory.

Approaches
==========

Simple
-----

1. Have GPG2 keys
2. Have a `~/.gnupg/gpg-agent.conf`
3. Start a `gpg-agent` as a daemon.
4. Try to encrypt a file with `gpg2`
	* `gpg2 --encrypt --sign --armor -r nobody@example.com linux-gpg2-agent-preset/README.md`

### Expected

File successfully encrypted

### Actual

`gpg2` interactively prompts for the GPG2 key's passphrase.

`git`
-----

1. Have GPG2 keys
2. Have a `~/.gnupg/gpg-agent.conf`
3. Start a `gpg-agent` as a daemon.
4. Configure `git` to use one of those keys to sign commits
5. Try to commit to this repository
		cd linux-gpg2-agent-preset
		hostname >> README.md
		git add README.md
		git commit -a -m 'signed commit'

### Expected

A signed commit is generated

### Actual

`git` interactively prompts for the GPG2 key's passphrase.

Notes
==========

* GPG keys: [`docker/files/home/ubuntu/.gnupg`](docker/files/home/ubuntu/.gnupg)
	* UID: `47625A42`
	* Passphrase: `correct horse battery staple`
* `gpg2` and `gpg-agent` versions: [`docker/installers/apt-get.sh`](docker/installers/apt-get.sh)

`gpg-agent` preset key validation
-----

The [internet says](https://unix.stackexchange.com/a/342461) that the way to validate if the `gpg-agent` has a passphrase set, is to run

	echo "KEYINFO --no-ask <keygrip> Err Pmt Des" | gpg-connect-agent

Initially, inside the Docker image the results of this look like:

	S KEYINFO 39677A426BF7F41FEEAECF8340B6B825F820E5DE D - - - P - - -
	OK

After correctly answering the interactive passphrase prompt, that same command produces output like this:

	S KEYINFO 39677A426BF7F41FEEAECF8340B6B825F820E5DE D - - 1 P - - -
	OK

So, I'm pretty sure that `/usr/lib/gnupg2/gpg-preset-passphrase` isn't actually working.

