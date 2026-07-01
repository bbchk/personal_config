# devcon/Makefile — build & push devcontainer images from definitions/*.json
#
# Each definitions/<name>[___<tags>].json is a full devcontainer.json. This
# Makefile builds one image per definition via the devcontainer CLI. Image name
# is the persona (the part before "___"), so:
#   definitions/zmiy___nvim-0.11.5_py_node-26.3.1.json -> $(REGISTRY)/devcon-zmiy
#   definitions/kozak.json                             -> $(REGISTRY)/devcon-kozak
#
# CI usage:
#   make -C devcon push TAG=$GIT_SHA          # build + push every image
#   make -C devcon push-zmiy                  # build + push a single image
#   make -C devcon build                      # build all locally (no push)
#
# The definitions reference the Dockerfile via ${localEnv:HOME}/pers/devcon, so
# the checkout MUST live at $HOME/pers (or override HOME for the build).

# ---- configuration (override on the CLI or in CI env) ----------------------
REGISTRY       ?= ghcr.io/bbchk/pers
IMAGE_PREFIX   ?= devcon-
TAG            ?= latest
# Single-arch on purpose — see README. Building amd64,arm64 doubles export time.
PLATFORM       ?= linux/amd64
# devcontainer.json is looked up relative to this; we pass --config explicitly,
# but ${localEnv:HOME} in the definitions still resolves from the environment.
WORKSPACE_FOLDER ?= $(HOME)
DEVCONTAINER   ?= devcontainer
# Extra flags forwarded to `devcontainer build` (e.g. --no-cache, --cache-from).
BUILD_ARGS     ?=

# ---- discovery -------------------------------------------------------------
DEFINITIONS := $(wildcard definitions/*.json)
# persona name = filename stem, truncated at the first "___"
name  = $(firstword $(subst ___, ,$(basename $(notdir $(1)))))
image = $(REGISTRY)/$(IMAGE_PREFIX)$(call name,$(1)):$(TAG)
NAMES := $(foreach d,$(DEFINITIONS),$(call name,$(d)))

# ---- meta targets ----------------------------------------------------------
.DEFAULT_GOAL := help
.PHONY: help list build push $(addprefix build-,$(NAMES)) $(addprefix push-,$(NAMES))

help: ## Show this help
	@echo "devcontainer image builds — targets:"
	@echo "  make build           build all images locally"
	@echo "  make push            build + push all images"
	@echo "  make build-<name>    build a single image (e.g. build-zmiy)"
	@echo "  make push-<name>     build + push a single image"
	@echo "  make list            list discovered definitions -> image names"
	@echo ""
	@echo "vars: REGISTRY=$(REGISTRY) IMAGE_PREFIX=$(IMAGE_PREFIX) TAG=$(TAG) PLATFORM=$(PLATFORM)"

list: ## List definitions and the image each maps to
	@$(foreach d,$(DEFINITIONS),printf '%-55s -> %s\n' '$(d)' '$(call image,$(d))';)

build: $(addprefix build-,$(NAMES)) ## Build every image locally
push:  $(addprefix push-,$(NAMES))  ## Build + push every image

# ---- per-definition rules (generated) --------------------------------------
# $(1) = definition path. Defines build-<name> and push-<name>.
define IMAGE_template
build-$(call name,$(1)):
	$$(DEVCONTAINER) build \
		--workspace-folder "$$(WORKSPACE_FOLDER)" \
		--config "$(1)" \
		--image-name "$(call image,$(1))" \
		--platform "$$(PLATFORM)" \
		$$(BUILD_ARGS)

push-$(call name,$(1)):
	$$(DEVCONTAINER) build \
		--workspace-folder "$$(WORKSPACE_FOLDER)" \
		--config "$(1)" \
		--image-name "$(call image,$(1))" \
		--platform "$$(PLATFORM)" \
		--push \
		$$(BUILD_ARGS)
endef

$(foreach d,$(DEFINITIONS),$(eval $(call IMAGE_template,$(d))))
