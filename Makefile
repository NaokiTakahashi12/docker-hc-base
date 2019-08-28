DOCKERFILE	:= Dockerfile

PROJECT		:= hc-base
ORIGIN		:= $(shell git remote get-url origin | sed -e 's/^.*@//g')
REVISION	:= $(shell git rev-parse --short HEAD)
USERNAME	:= naokitakahashi12

TRUSTY := trusty
XENIAL := xenial
BIONIC := bionic

define dockerbuild
	@docker build \
		--file $1 \
		--build-arg GIT_REVISION=$(REVISION) \
		--build-arg GIT_ORIGIN=$(REVISION) \
		--tag $2 \
	.
endef

.PHONY: build
build: $(TRUSTY) $(XENIAL) $(BIONIC)

$(TRUSTY): $(DOCKERFILE).$(TRUSTY)
	$(eval DOCKERIMAGE := "$(USERNAME)/$(PROJECT):$@")
	$(call dockerbuild, $<, $(DOCKERIMAGE))

$(XENIAL): $(DOCKERFILE).$(XENIAL)
	$(eval DOCKERIMAGE := "$(USERNAME)/$(PROJECT):$@")
	$(call dockerbuild, $<, $(DOCKERIMAGE))

$(BIONIC): $(DOCKERFILE).$(BIONIC)
	$(eval DOCKERIMAGE := "$(USERNAME)/$(PROJECT):$@")
	$(call dockerbuild, $<, $(DOCKERIMAGE))

.PHONY: clean
clean: $(TRUSTY)
	@for IMAGETAG in $^; do \
		docker image rm $(USERNAME)/$(PROJECT):$$IMAGETAG; \
	done

.PHONY: pull
pull: $(TRUSTY)
	@for IMAGETAG in $^; do \
		docker pull $(USERNAME)/$(PROJECT):$$IMAGETAG; \
	done

