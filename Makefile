# Variables
DOCKER_REGISTRY=langgenius
WEB_IMAGE=$(DOCKER_REGISTRY)/dify-web
API_IMAGE=$(DOCKER_REGISTRY)/dify-api
VERSION=latest

print:
	@echo "DOCKER_REGISTRY: $(DOCKER_REGISTRY)"
	@echo "WEB_IMAGE: $(WEB_IMAGE)"
	@echo "API_IMAGE: $(API_IMAGE)"
	@echo "VERSION: $(VERSION)"
# $ make print
# DOCKER_REGISTRY: langgenius
# WEB_IMAGE: langgenius/dify-web
# API_IMAGE: langgenius/dify-api
# VERSION: latest

# Build Docker images
build-web:
	@echo "Building web Docker image: $(WEB_IMAGE):$(VERSION)..."
	docker build -t $(WEB_IMAGE):$(VERSION) ./web
	@echo "Web Docker image built successfully: $(WEB_IMAGE):$(VERSION)"
# $ make -n --just-print build-web
# echo "Building web Docker image: langgenius/dify-web:latest..."
# docker build -t langgenius/dify-web:latest ./web
# echo "Web Docker image built successfully: langgenius/dify-web:latest"
# $

build-api:
	@echo "Building API Docker image: $(API_IMAGE):$(VERSION)..."
	docker build -t $(API_IMAGE):$(VERSION) ./api
	@echo "API Docker image built successfully: $(API_IMAGE):$(VERSION)"
# $ make -n --just-print build-api
# echo "Building API Docker image: langgenius/dify-api:latest..."
# docker build -t langgenius/dify-api:latest ./api
# echo "API Docker image built successfully: langgenius/dify-api:latest"
# $

# Push Docker images
push-web:
	@echo "Pushing web Docker image: $(WEB_IMAGE):$(VERSION)..."
	docker push $(WEB_IMAGE):$(VERSION)
	@echo "Web Docker image pushed successfully: $(WEB_IMAGE):$(VERSION)"
# $ make -n --just-print push-web
# echo "Pushing web Docker image: langgenius/dify-web:latest..."
# docker push langgenius/dify-web:latest
# echo "Web Docker image pushed successfully: langgenius/dify-web:latest"
# $

push-api:
	@echo "Pushing API Docker image: $(API_IMAGE):$(VERSION)..."
	docker push $(API_IMAGE):$(VERSION)
	@echo "API Docker image pushed successfully: $(API_IMAGE):$(VERSION)"
# $ make -n --just-print push-api
# echo "Pushing API Docker image: langgenius/dify-api:latest..."
# docker push langgenius/dify-api:latest
# echo "API Docker image pushed successfully: langgenius/dify-api:latest"
# $

# Build all images
build-all: build-web build-api

# Push all images
push-all: push-web push-api

build-push-api: build-api push-api
build-push-web: build-web push-web

# Build and push all images
build-push-all: build-all push-all
	@echo "All Docker images have been built and pushed."

# Phony targets
.PHONY: build-web build-api push-web push-api build-all push-all build-push-all
