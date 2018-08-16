build:
	docker build -t linux-gpg2-agent-preset .

run:
	docker run \
		--rm \
		--interactive \
		--tty \
		--volume="$(CURDIR)":/home/ubuntu/linux-gpg2-agent-preset \
			linux-gpg2-agent-preset