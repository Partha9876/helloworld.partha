# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

LABEL maintainer="Partha sarathi <parthasarathi2426@gmail.com>"
LABEL version="1.0"

# [OPTIONAL]
# Add Microsoft package repository and install .NET SDK and ASP.NET Core runtime
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
  -O packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb;

# Extra logs
RUN pwd
RUN whoami

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ConsoleHelloWorldPartha/*.csproj ./ConsoleHelloWorldPartha/
RUN dotnet restore

# copy everything else and build app
COPY ConsoleHelloWorldPartha/. ./ConsoleHelloWorldPartha/
WORKDIR /source/ConsoleHelloWorldPartha
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ConsoleHelloWorldPartha.dll"]
