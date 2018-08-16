#!/usr/bin/env bash

gpg-agent --version
gpg2 --version
gpg2 --list-secret-keys

KEY_ID=${KEY_ID-47625A42}
KEY_PASSPHRASE=${KEY_PASSPHRASE-correct horse battery staple}

set -x

# Set up Git to use GPG
git config --global user.signingkey ${KEY_ID}
git config --global gpg.program `which gpg2`
git config --global commit.gpgsign true

# Start a long-running gpg-agent
gpg-agent \
	--daemon
ps aux

# preset the passphrase for the key.

# first, get the key's fingerprint.
KEY_FINGERPRINT=$(gpg2 --fingerprint --fingerprint $KEY_ID | grep -Po "Key fingerprint = (.*)" | head -1 | sed 's/Key fingerprint = //' | sed 's/ *//g')
ps aux

# then, load up the passphrase:
/usr/lib/gnupg2/gpg-preset-passphrase \
	--preset \
	--passphrase "${KEY_PASSPHRASE}" \
		"${KEY_FINGERPRINT}"
ps aux

# Show the gpg-agent's cache for this key:
KEY_GRIP=$(gpg2 --fingerprint --with-keygrip ${KEY_ID} | grep -Po "Keygrip = (.*)" | head -1 | sed 's/Keygrip = //' | sed 's/ *//g')
echo "KEYINFO --no-ask ${KEY_GRIP} Err Pmt Des" | gpg-connect-agent
ps aux

# enable interactive prompting for passphrase when the presetting fails.
GPG_TTY=$(tty)
export GPG_TTY

exec "$@"