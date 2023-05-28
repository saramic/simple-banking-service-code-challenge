.DEFAULT_GOAL := install-and-build

# user and repo
USER        = $$(whoami)
CURRENT_DIR = $(notdir $(shell pwd))

# terminal colours
RED     = \033[0;31m
GREEN   = \033[0;32m
YELLOW  = \033[0;33m
NC      = \033[0m

.PHONY: check-tools
check-tools:
	bin/makefile/check-tools

.PHONY: install
install: check-tools
	bundle

.PHONY: rubocop-fix
rubocop-fix:
	bundle exec rubocop -A

.PHONY: rubocop
rubocop:
	bundle exec rubocop

.PHONY: rspec
rspec:
	bundle exec rspec

.PHONY: demo
demo:
	@echo "${RED}TODO actually make a demo${NC}"
	bin/simple_banking_service.rb mable_acc_balance.csv mable_trans.csv

.PHONY: build
build: rspec demo

.PHONY: pre-build-message
pre-build-message:
	@echo "\n\trun ${GREEN}make usage${NC} to see other usage options\n"

.PHONY: post-build-message
post-build-message:
	@echo "\n\trun ${GREEN}make usage${NC} to see other usage options"
	@echo "\trun ${GREEN}make build${NC} to just run specs and app\n"

.PHONY: install-and-build
install-and-build: pre-build-message install rubocop build post-build-message

.PHONY: usage
usage:
	@echo
	@echo "Hi ${GREEN}${USER}!${NC} Welcome to ${RED}${CURRENT_DIR}${NC}"
	@echo
	@echo "Getting started"
	@echo
	@echo "${YELLOW}make${NC}              install, test and run the demo"
	@echo "${YELLOW}make check-tools${NC}  check right tools (ruby) are installed"
	@echo "${YELLOW}make build${NC}        test and run the demo"
	@echo "${YELLOW}make usage${NC}        this menu"
	@echo
	@echo "Development"
	@echo
	@echo "${YELLOW}make rubocop${NC}      rubocop"
	@echo "${YELLOW}make rubocop-fix${NC}  rubocop fix"
	@echo "${YELLOW}make rspec${NC}        rubocop fix"
	@echo
