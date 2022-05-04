.PHONY: default clean clean_binaries list_binaries run build_release build_release_trimmed docker_build_alpine_amd64 slim docker_build_alpine_amd64_single_file slim_single_file

default: slim slim_single_file

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

build_release_trimmed:
	dotnet build -c Release -r linux-musl-x64 -p:PublishTrimmed=true

docker_build_alpine_amd64:
	docker build -f Dockerfile -t minicsharp .
	docker images minicsharp

docker_build_alpine_amd64_single_file:
	docker build -f Dockerfile -t minicsharp:single_file --build-arg SINGLE_FILE=true .
	docker images minicsharp:single_file

slim: docker_build_alpine_amd64
	docker-slim build minicsharp
	docker images minicsharp.slim

slim_single_file: docker_build_alpine_amd64_single_file
	docker-slim build --tag minicsharp:single_file_slim minicsharp:single_file
	docker images minicsharp:single_file_slim
