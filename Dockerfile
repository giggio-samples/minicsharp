FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-alpine as base
WORKDIR /app
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["minicsharp.csproj", "./"]
RUN dotnet restore -r linux-musl-x64 minicsharp.csproj
COPY . .
RUN dotnet publish minicsharp.csproj --self-contained -c Release -r linux-musl-x64 -p:PublishTrimmed=true -o /app/publish

FROM base
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["/app/minicsharp"]