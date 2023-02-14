SHELL := /usr/bin/env -S bash -e
.PHONY: install help systemd systemdcheck cron

all: help

install: ## Do sync command installation. Usage: $ git sync
	$(info Install all you need to use this Sync.)
	@bash -e install-default.sh

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1;32m%-15s \033[1;33m%s\033[0m\n", $$1, $$2}'

systemd: install ## Do systemd service installation. Usage: $ systemctl status --user <repo name>-sync.timer <repo name>-sync.service
	$(info Install Systemd service.)
	@bash -e ./install-systemd.sh

cron: install ## Create a job for cron. Usage: $ cat ~/.<repo name>-sync.log
	$(info Install Cron job.)
	@bash -e ./install-cron.sh
