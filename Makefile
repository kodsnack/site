.PHONY: serve deploy all

all: deploy

serve:
	@hugo server --theme=kodsnack --buildDrafts --watch

deploy:
	@hugo --theme=kodsnack -d ${DEST}

