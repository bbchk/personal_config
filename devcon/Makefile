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

# Features publish to <FEATURE_REGISTRY>/<FEATURE_NAMESPACE>/<id> — the images
# above consume ghcr.io/bbchk/pers/<id>, so features must be published first.
FEATURE_REGISTRY  ?= ghcr.io
FEATURE_NAMESPACE ?= bbchk/pers

# ---- discovery -------------------------------------------------------------
DEFINITIONS := $(wildcard definitions/*.json)
# persona name = filename stem, truncated at the first "___"
name  = $(firstword $(subst ___, ,$(basename $(notdir $(1)))))
image = $(REGISTRY)/$(IMAGE_PREFIX)$(call name,$(1)):$(TAG)
NAMES := $(foreach d,$(DEFINITIONS),$(call name,$(d)))

# feature dirs = any subdir holding a devcontainer-feature.json (helper, neovim, ...)
FEATURE_NAMES := $(patsubst %/,%,$(dir $(wildcard */devcontainer-feature.json)))

# ---- meta targets ----------------------------------------------------------
.DEFAULT_GOAL := help
.PHONY: help list build push features-publish \
	$(addprefix build-,$(NAMES)) $(addprefix push-,$(NAMES)) \
	$(addprefix features-publish-,$(FEATURE_NAMES)) \
	$(addprefix bump-,$(FEATURE_NAMES))

help: ## Show this help
	@echo "devcontainer image builds — targets:"
	@echo "  make build                    build all images locally"
	@echo "  make push                     build + push all images"
	@echo "  make build-<name>             build a single image (e.g. build-zmiy)"
	@echo "  make push-<name>              build + push a single image"
	@echo "  make features-publish         publish all features (do this before push)"
	@echo "  make features-publish-<name>  publish a single feature (e.g. neovim)"
	@echo "  make list                     list definitions/features -> targets"
	@echo ""
	@echo "images:   REGISTRY=$(REGISTRY) IMAGE_PREFIX=$(IMAGE_PREFIX) TAG=$(TAG) PLATFORM=$(PLATFORM)"
	@echo "features: $(FEATURE_REGISTRY)/$(FEATURE_NAMESPACE)/<id>"

list: ## List definitions and the image each maps to
	@echo "images:"
	@$(foreach d,$(DEFINITIONS),printf '  %-55s -> %s\n' '$(d)' '$(call image,$(d))';)
	@echo "features:"
	@$(foreach f,$(FEATURE_NAMES),printf '  %-55s -> %s\n' '$(f)/' '$(FEATURE_REGISTRY)/$(FEATURE_NAMESPACE)/$(f)';)

build: $(addprefix build-,$(NAMES)) ## Build every image locally
push:  $(addprefix push-,$(NAMES))  ## Build + push every image
features-publish: $(addprefix features-publish-,$(FEATURE_NAMES)) ## Publish every feature

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

# ---- per-feature rules (generated) -----------------------------------------
# $(1) = feature dir name. Publishes <FEATURE_REGISTRY>/<FEATURE_NAMESPACE>/<id>.
# Auto-bumps the patch version in the feature's devcontainer-feature.json first,
# so every publish lands a fresh, monotonically increasing version. Set
# BUMP=0 to publish the existing version as-is (e.g. re-runs / dry checks).
BUMP ?= 1
define FEATURE_template
features-publish-$(1): bump-$(1)
	$$(DEVCONTAINER) features publish \
		--registry "$$(FEATURE_REGISTRY)" \
		--namespace "$$(FEATURE_NAMESPACE)" \
		"$(1)"

bump-$(1):
	@[ "$$(BUMP)" = "0" ] && exit 0; \
	f="$(1)/devcontainer-feature.json"; \
	cur=$$$$(jq -r '.version' "$$$$f"); \
	new=$$$$(echo "$$$$cur" | awk -F. 'NF==3{printf "%d.%d.%d",$$$$1,$$$$2,$$$$3+1}'); \
	[ -n "$$$$new" ] || { echo "$$$$f: version '$$$$cur' is not X.Y.Z" >&2; exit 1; }; \
	tmp=$$$$(mktemp); \
	jq --arg v "$$$$new" '.version=$$$$v' "$$$$f" > "$$$$tmp" && mv "$$$$tmp" "$$$$f"; \
	echo "$(1): bumped $$$$cur -> $$$$new"
endef

$(foreach f,$(FEATURE_NAMES),$(eval $(call FEATURE_template,$(f))))



# ● The Makefile works. Verified via dry-run: it auto-discovers all 6 definitions, derives image names from the persona (part before ___), and emits correct devcontainer build invocations.
#   
#   What I built
#
#   devcon/Makefile — builds one image per definitions/*.json using the devcontainer CLI.
#
#   Targets:
#   - make build / make push — all images (push = build + --push)
#   - make build-<name> / make push-<name> — single image (e.g. push-zmiy)
#   - make list — shows the definition → image-name mapping
#   - make help — default target, summary + current vars
#
#   Image naming: definitions/zmiy___nvim-0.11.5_py_node-26.3.1.json → ghcr.io/bbchk/pers/devcon-zmiy:latest. The ___tags suffix is stripped so the tag string in the filename can change without changing the image name.
#
#   Overridable vars (for CI):
#   - REGISTRY (default ghcr.io/bbchk/pers), IMAGE_PREFIX (devcon-), TAG (latest)
#   - PLATFORM (linux/amd64 — single-arch, per your README note #6)
#   - WORKSPACE_FOLDER ($HOME), BUILD_ARGS (forwards --no-cache, --cache-from, etc.)
#
#   CI usage:
#   make -C devcon push TAG=$GIT_SHA
#   make -C devcon push-zmiy
#
#   Two things to flag
#
#   1. Checkout location constraint (not introduced by the Makefile). The definitions hardcode dockerfile: ${localEnv:HOME}/pers/devcon/Dockerfile and context: ${localEnv:HOME}. So in CI the repo must sit at $HOME/pers, or you
#   override HOME for the build step. This is an existing property of your definitions — I documented it in the Makefile header but didn't change the definitions.
#   2. Features vs. images are separate concerns. This Makefile builds the devcontainer images. Your features (helper, neovim, ros2, lua, kafka) are published separately via devcontainer features publish — and the images depend
#   on those features being published first (ghcr.io/bbchk/pers/neovim:latest, etc.).
#
#   Want me to add a features-publish target too, so CI can do features-then-images in order? And/or scaffold the GitHub Actions workflow (your README TODO #3) that calls these targets?
