TAG := latest

COMMON_ARGS = --progress=plain
COMMON_ARGS += --frontend=dockerfile.v0
COMMON_ARGS += --local context=.
COMMON_ARGS += --local dockerfile=.

BUILDKIT_HOST ?= docker-container://buildkitd

all: toolchain

.PHONY: core
core:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=tars/$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)

.PHONY: base
base:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=tars/$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)

.PHONY: extras
extras:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=tars/$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)

.PHONY: golang
golang:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=tars/$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)

.PHONY: protoc
protoc:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=tars/$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)

.PHONY: images
images:
	@source ./versions.sh

.PHONY: toolchain
toolchain:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=tars/$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)
	@docker load < tars/$@.tar

.PHONY: common-base
common-base:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)
	@docker load < tars/$@.tar

.PHONY: rootfs-base
rootfs-base:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)
	@docker load < tars/$@.tar

.PHONY: initramfs-base
initramfs-base:
	@buildctl --addr $(BUILDKIT_HOST) \
		build \
		--output type=docker,dest=$@.tar,name=daos/$@:$(TAG) \
		--opt target=$@ \
		$(COMMON_ARGS)
	@docker load < tars/$@.tar

