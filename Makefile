SHELL                 = /bin/sh

MODULE_NAME			  = gitlab.com/ayobisa/infra-playground
ifeq ($(APP_NAME),)
APP_NAME              = ayobisa
endif
PREFIX				  = staging-
ifeq ($(ENV),main)
PREFIX				  =
endif
ifeq ($(ENV),master)
PREFIX				  =
endif
DOCKERFILE 			  = ${ARGS}
ifeq ($(DOCKERFILE),)
	DOCKERFILE 		  = Dockerfile
endif
VERSION               = $(shell git describe --always --tags)
GIT_COMMIT            = $(shell git rev-parse HEAD)
GIT_DIRTY             = $(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_DATE            = $(shell date '+%Y-%m-%d-%H:%M:%S')

.PHONY: default
default: help

.PHONY: help
help:
	@echo 'Management commands for ${APP_NAME}:'
	@echo
	@echo 'Usage:'
	@echo '    make build                              Build the project docker images.'
	@echo '    make push                               Push Docker image.'
	@echo '    make run ARGS=                          Run with supplied arguments.'
	@echo '    make infra                              Create EKS infra-structure.'
	@echo '    make infra                              Create EKS infra-structure.'
	@echo '    make infra                              Create EKS infra-structure.'
	@echo '    make infra                              Create EKS infra-structure.'
	@echo

.PHONY: build
build:
	@echo "Building backend"
	docker buildx build -t backend:latest --load ./frontend
	@echo "Building frontend"
	docker buildx build -t frontend:latest --load ./frontend
	@echo "===============================\n"

.PHONY: push
push:
	@echo "Building ${APP_NAME} ${VERSION}"
	GOOS=linux GOARCH=amd64 go build -ldflags "-w -X ${MODULE_NAME}${APP_NAME}/version.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X ${MODULE_NAME}${APP_NAME}/version.Version=${VERSION} -X ${MODULE_NAME}${APP_NAME}/version.Environment=${ENV} -X ${MODULE_NAME}${APP_NAME}/version.BuildDate=${BUILD_DATE}" -o bin/${APP_NAME}
	@echo "===============================\n"


.PHONY: run
run: build
	@echo "Running ${APP_NAME} ${VERSION}"
	@echo "===============================\n"
	bin/${APP_NAME} ${ARGS}

.PHONY: infra
infra:
	@go test ./... --cover | awk '{if ($$1 != "?") print $$2 " " $$5;}' | sed 's/\%//g' | awk '{ print $$1 " | coverage: " $$2 "%"; sum += $$2; n++ } END { if (n > 0) printf "AVG coverage project directory = %.2f%%\n", sum/n }'

.PHONY: clean
clean:
	@echo "Removing ${APP_NAME} ${VERSION}"
	@test ! -e bin/${APP_NAME} || rm bin/${APP_NAME}


.PHONY: loadtest
loadtest:
	@echo "Soon..."
