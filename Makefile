.PHONY: compose

compose: .env
	docker compose --progress=plain up --build

.env:
ifeq ("$(wildcard $@)", "")
	echo 'export OPENSKY_USER="username"\nexport OPENSKY_PASS="password"' >$@
else
	touch $@
endif
