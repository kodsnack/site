.PHONY: serve deploy all

all: deploy

international:
	grep -l "^english\s\?=\s\?true" content/avsnitt/*.md | xargs -I args cp -f args content/international/

# Pagefind will not be reindexed on hot reloads when saving 
# changes, but the --serve pagefind provides does not have 
# that feature so this will have to do
serve: international
	@hugo --theme=kodsnack --buildFuture --buildDrafts
	@bin/pagefind --site public
	@hugo server --theme=kodsnack --buildFuture --buildDrafts --watch

deploy: international
	@hugo --theme=kodsnack --buildFuture --buildExpired --enableGitInfo -d ${DEST} >> /mnt/persist/hugo.log 2>&1
	@bin/pagefind --site ${DEST} >> logdir/hugo.log 2>&1
	@hugo --theme=kodsnack -D --buildFuture --buildExpired --enableGitInfo -d ${BETA_DEST} >> /mnt/persist/hugo.log 2>&1
	@bin/pagefind --site ${BETA_DEST} >> logdir/hugo.log 2>&1
  