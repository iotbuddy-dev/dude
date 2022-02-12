# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2022-02-12
- Add `prepare-multiarch-docker` action and refactor workflow.

## [Unreleased] - 2022-02-03
- Refactor workflow and Dockerfile.
- Add lint stage running `go vet` and `staticcheck`.

## [Unreleased] - 2022-01-22
- Merge Dockerfile.dev and Dockerfile.builder into one multi-stage Dockerfile.
- Add docker image building for arm64 architecture in CI workflow.
- Add docker-compose.yml file with mongodb container for devcontainer usage.
- Add test stage and run them in Docker using `go test` in CI workflow.

## [Unreleased] - 2021-12-11
- Init repository with base files.
- Add dev Dockerfile.
- Configure devcontainer for VSCode.
- Add builder Dockerfile.
- Config CI (GitHub Workflow).
- Setup simple web server with /hello endpoint.
