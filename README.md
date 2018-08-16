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
This repository will be present (via a Docker bind-mount) in your home directory:

	~/git-personal/linux-gpg2-agent-preset (master) $ make run
	docker run \
			--rm \
			--interactive \
			--tty \
			--volume="/Users/me/git-personal/linux-gpg2-agent-preset":/home/ubuntu/linux-gpg2-agent-preset \
				linux-gpg2-agent-preset
	/home/ubuntu/.gnupg/pubring.kbx
	-------------------------------
	sec   rsa4096/47625A42 2018-08-16 [SC]
	uid         [ultimate] Dummy Key (This keypair was generated as part of an example repo; the private key and passphrase are known to the world.) <nobody@example.com>
	ssb   rsa4096/58972FCE 2018-08-16 [E]
	...
	+ exec bash
	ubuntu@3cab7eb59cd2:~$ ls -hal
	total 16K
	drwxr-xr-x  1 ubuntu root   4.0K Aug 16 02:16 .
	drwxr-xr-x  1 root   root   4.0K Aug 16 00:58 ..
	-rw-r--r--  1 ubuntu ubuntu   86 Aug 16 02:16 .gitconfig
	drwx------  1 ubuntu root   4.0K Aug 16 02:16 .gnupg
	drwxr-xr-x 10 ubuntu ubuntu  340 Aug 16 02:07 linux-gpg2-agent-preset

Approaches
==========

Simple
-----

1. Have GPG2 keys
2. Have a `~/.gnupg/gpg-agent.conf`
3. Start a `gpg-agent` as a daemon.
4. Try to encrypt a file with `gpg2`
	* `gpg2 --encrypt --sign --armor -r nobody@example.com linux-gpg2-agent-preset/README.md`

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

Notes
==========

* GPG keys: [`docker/files/home/ubuntu/.gnupg`](docker/files/home/ubuntu/.gnupg)
	* UID: `47625A42`
	* Passphrase: `correct horse battery staple`
* `gpg2` and `gpg-agent` versions: [`docker/installers/apt-get.sh`](docker/installers/apt-get.sh)
