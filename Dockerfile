ARG GO_VERSION=1.16
ARG ALPINE_VERSION=3.15

# --- Base stage ---
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine${ALPINE_VERSION} as base

ARG TARGETOS TARGETARCH
ENV GCO_ENABLED=0
RUN apk update && apk upgrade && \
    apk add --no-cache staticcheck build-base

# --- Develop env stage ---
FROM base as dev

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

# Setup user
RUN adduser $USERNAME -s /bin/sh -D -u $USER_UID $USER_GID && \
    mkdir -p /etc/sudoers.d && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Install packages and Go language server
RUN apk update && apk upgrade && \
    apk add --no-cache git sudo openssh-client zsh
RUN go install golang.org/x/tools/gopls@latest

# Setup shell
USER $USERNAME
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended &> /dev/null
ENV ENV="/home/$USERNAME/.ashrc" \
    ZSH=/home/$USERNAME/.oh-my-zsh \
    EDITOR=vi \
    LANG=en_US.UTF-8
RUN printf 'ZSH_THEME="candy"\nENABLE_CORRECTION="false"\nplugins=(git copyfile extract colorize dotenv encode64 golang)\nsource $ZSH/oh-my-zsh.sh' > "/home/$USERNAME/.zshrc"
RUN echo "exec `which zsh`" > "/home/$USERNAME/.ashrc"
USER vscode

# --- Base for targets in CI workflow ---
FROM base as ci-base

ENV GCO_ENABLED=0
WORKDIR /app
COPY /app .
RUN go mod download

# --- Build stage ---
FROM ci-base as build 

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o build/dude

# --- Test stage ---
FROM ci-base as test

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH CGO_ENABLED=0 go test -coverprofile=coverage.out ./...

# --- Lint stage ---
FROM ci-base as lint

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH CGO_ENABLED=0 go vet ./...
RUN staticcheck ./...

# Deploy stage
FROM alpine:${ALPINE_VERSION} as deploy

WORKDIR /app
COPY --from=build /app/build .
EXPOSE 8080
ENTRYPOINT ["./dude"]
