.PHONY: serve deploy all

all: deploy

international:
	grep -l "^english\s\?=\s\?true" content/avsnitt/*.md | xargs cp -ft content/international/

serve: international
	@hugo server --theme=kodsnack --buildDrafts --watch

deploy: international
	@hugo --theme=kodsnack --buildFuture --buildExpired --enableGitInfo --logFile /mnt/persist/hugo.log -d ${DEST}
	@hugo --theme=kodsnack -D --buildFuture --buildExpired --enableGitInfo --logFile /mnt/persist/hugo.log -d ${BETA_DEST}
