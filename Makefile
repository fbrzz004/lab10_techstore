.PHONY: deploy backend web push verify

deploy:
	python3 scripts/deploy.py

backend:
	python3 scripts/deploy.py --solo-backend

web:
	python3 scripts/deploy.py --solo-web

push:
	bash scripts/push.sh "$(m)"

verify:
	bash scripts/verificar.sh
