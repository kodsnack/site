.PHONY: serve deploy all

all: deploy

serve:
	@hugo server --theme=kodsnack --buildDrafts --watch

deploy:
	@hugo --theme=kodsnack --forceSyncStatic --enableGitInfo --logFile /mnt/persist/hugo.log -d ${DEST}
	@hugo --theme=kodsnack -D --verboseLog --forceSyncStatic --enableGitInfo --logFile /mnt/persist/hugo.log -d ${BETA_DEST}

