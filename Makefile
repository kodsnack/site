.PHONY: serve deploy all

all: deploy

serve:
	@hugo server --theme=kodsnack --buildDrafts --watch

deploy:
	@hugo --theme=kodsnack --buildFuture --buildExpired --enableGitInfo --logFile /mnt/persist/hugo.log -d ${DEST}
	@hugo --theme=kodsnack -D --buildFuture --buildExpired --enableGitInfo --logFile /mnt/persist/hugo.log -d ${BETA_DEST}
