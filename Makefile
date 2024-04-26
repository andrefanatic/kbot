TARGETOS=$(shell uname -s | tr '[:upper:]' '[:lower:]')
TARGETARCH=$(shell dpkg --print-architecture)

APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=andriy1fanatic
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format get
	@echo Target OS/ARCH ${TARGETOS} / ${TARGETARCH}
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/andrefanatic/kbot/cmd.appVersion=${VERSION}

linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/andrefanatic/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg name=linux -t ${REGISTRY}/${APP}:${VERSION}-linux-${TARGETARCH} .

windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/andrefanatic/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg name=windows -t ${REGISTRY}/${APP}:${VERSION}-windows-${TARGETARCH} .

darwin: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/andrefanatic/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg name=darwin -t ${REGISTRY}/${APP}:${VERSION}-darwin-${TARGETARCH} .

arm: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=arm go build -v -o kbot -ldflags "-X="github.com/andrefanatic/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg name=arm -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-arm .

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi -f $$(docker images -q | head -n 1)