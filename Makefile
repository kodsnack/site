.PHONY: serve deploy all

all: deploy

serve:
	@hugo server --theme=kodsnack --buildDrafts --watch

deploy:
	@rm -rf public/*
	@hugo --theme=kodsnack

