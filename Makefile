.PHONY: serve deploy all

all: deploy

international:
	grep -l "^english\s\?=\s\?true" content/avsnitt/*.md | xargs -I args cp -f args content/international/

serve: international
	@hugo server --theme=kodsnack --buildDrafts --watch

deploy: international
	@hugo --theme=kodsnack --buildFuture --buildExpired --enableGitInfo --logFile /mnt/persist/hugo.log -d ${DEST}
	@hugo --theme=kodsnack -D --buildFuture --buildExpired --enableGitInfo --logFile /mnt/persist/hugo.log -d ${BETA_DEST}
