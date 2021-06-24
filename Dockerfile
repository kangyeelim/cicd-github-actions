FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT Production

# copy csproj and restore as distinct layers
COPY Basic-API-dotnet/*.csproj Basic-API-dotnet/
WORKDIR /app/Basic-API-dotnet
RUN dotnet restore

# copy and publish app and libraries
WORKDIR /app
COPY Basic-API-dotnet/. Basic-API-dotnet/
WORKDIR /app/Basic-API-dotnet
RUN dotnet build
RUN dotnet publish -c release -o out

# copy build artifacts into runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
EXPOSE 5000/tcp
ENV ASPNETCORE_URLS http://*:5000
WORKDIR /app
COPY --from=build /app/Basic-API-dotnet/out ./
ENTRYPOINT ["dotnet", "Basic-API-dotnet.dll"]