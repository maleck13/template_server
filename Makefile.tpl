SHELL = /bin/bash
VERSION = 0.0.1
NAME = {{index . "app"}}
# default package to test
BUILDARGS = -ldflags "-X main.Version=v$(VERSION)"
BUILDENVS =

# To build for a os you are not on, use:
# make build GOOS=linux

# To compile for linux, create the docker image
# and push it to docker.io/feedhenry/negotiator with the version specified above, use:
# make docker_build_push GOOS=linux

# This is the first target, so it is the default, i.e.
# make for_linux is the same as make for_linux build
.PHONY: build
build: build_app

.PHONY: build_app
build_app:
	cd cmd/server && ${BUILDENVS} go build ${BUILDARGS}

.PHONY: docker_build
docker_build: build
	cd cmd/server && docker build -t {{index . "app"}}:${VERSION} .

.PHONY: for_linux
for_linux:
    BUILDENVS += env GOOS=linux

.PHONY: all
all:
	@go install -v

.PHONY: clean
clean:
	@-go clean -i

.PHONY: ci
ci: test test-race

# goimports doesn't support the -s flag to simplify code, therefore we use both
# goimports and gofmt -s.
.PHONY: check-gofmt
check-gofmt:
	diff <(gofmt -d -s .) <(printf "")

.PHONY: check-golint
check-golint:
	diff <(golint ./... | grep -v vendor/) <(printf "")

.PHONY: vet
vet:
	go vet ./...

.PHONY: test-unit
test-unit:
	env DEPENDENCY_TIMEOUT=5 go test -short -v --cover -cpu=2 `go list ./... | grep -v /vendor/`

.PHONY: test-race
test-race:
	go test -v -cpu=1,2,4 -short -race `go list ./... | grep -v /vendor/`

.PHONY: deps
deps:
	go get github.com/c4milo/github-release
	go get github.com/mitchellh/gox

.PHONY: compile
compile:
	@rm -rf build/
	@gox -ldflags "-X main.Version=v$(VERSION)" \
	-osarch="darwin/amd64" \
	-osarch="linux/amd64" \
	-output "build/{{.Dir}}_v$(VERSION)_{{.OS}}_{{.Arch}}/$(NAME)" \
	./...

dist: compile
	$(eval FILES := $(shell ls build))
	@rm -rf dist && mkdir dist
	@for f in $(FILES); do \
		(cd $(shell pwd)/build/$$f && tar -cvzf ../../dist/$$f.tar.gz *); \
		(cd $(shell pwd)/dist && shasum -a 512 $$f.tar.gz > $$f.sha512); \
		echo $$f; \
	done

#.PHONY: release
#release: dist
#	@latest_tag=$$(git describe --tags `git rev-list --tags --max-count=1`); \
	comparison="$$latest_tag..HEAD"; \
	if [ -z "$$latest_tag" ]; then comparison=""; fi; \
	changelog=$$(git log $$comparison --oneline --no-merges --reverse); \
	github-release feedhenry/$(NAME) v$(VERSION) "$$(git rev-parse --abbrev-ref HEAD)" "**Changelog**<br/>$$changelog" 'dist/*';