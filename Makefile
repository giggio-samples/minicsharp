.PHONY: default clean clean_binaries list_binaries run build_release build_release_trimmed docker_build_alpine_amd64 slim

default: slim

clean:
	dotnet clean

clean_binaries:
	rm -rf bin obj

list_binaries:
	ls -lahSr bin/{Release,Debug}/net6.0/minicsharp

run:
	dotnet run

build_release:
	dotnet build -c Release

build_release_trimmed:
	dotnet build -c Release -r linux-musl-x64 -p:PublishTrimmed=true

docker_build_alpine_amd64:
	docker build -f Dockerfile -t minicsharp .
	docker images minicsharp

slim: docker_build_alpine_amd64
	docker-slim build minicsharp
	docker images minicsharp.slim
