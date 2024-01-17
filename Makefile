.PHONY: all build run test

all:
	@docker buildx build --cache-from ghcr.io/nicholasdille/minecraft:latest --tag ghcr.io/nicholasdille/minecraft:latest --load .

run:
	@docker run --rm -it --env EULA=true --publish 127.0.0.1:25565:25565 ghcr.io/nicholasdille/minecraft:latest

test:
	@docker run --rm -it --env EULA=true --volume $$PWD/test:/var/opt/papermc --publish 127.0.0.1:25565:25565 ghcr.io/nicholasdille/minecraft:latest