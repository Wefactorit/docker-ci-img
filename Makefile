TERRAFORM_VERSION ?= 0.12.24
ANSIBLE_VERSION ?= 2.9.6
AWSCLI_VERSION ?= 1.18.46

REGISTRY_URL ?= docker.pkg.github.com
IMAGE_NAME = dck-ci-runner
PROJECT ?= wefactorit/docker-ci-img
REMOTE_NAME = $(REGISTRY_URL)/${PROJECT}/$(IMAGE_NAME)
IMAGE_VERSION ?= test

default: build

.PHONY: build
build:
	docker build \
		--build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
		--build-arg ANSIBLE_VERSION=${ANSIBLE_VERSION} \
		--build-arg AWSCLI_VERSION=${AWSCLI_VERSION} \
		-t build/$(IMAGE_NAME):$(IMAGE_VERSION) . --no-cache --pull

.PHONY: trivy
trivy:
	@if which trivy &> /dev/null ; then \
		echo "Checking image with Trivy..." ; \
		trivy --exit-code 1 build/$(IMAGE_NAME):$(IMAGE_VERSION) ; \
	else \
		echo "Not checking image because Trivy binary not found in path" ; \
	fi

.PHONY: tag
tag: build trivy
	docker tag build/$(IMAGE_NAME):$(IMAGE_VERSION) $(REMOTE_NAME):$(IMAGE_VERSION)

.PHONY: push
push: tag
	docker push $(REMOTE_NAME):$(IMAGE_VERSION)