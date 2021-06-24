FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT Production

# copy csproj and restore as distinct layers
COPY WebApplication/*.csproj WebApplication/
WORKDIR /app/WebApplication
RUN dotnet restore

# copy and publish app and libraries
WORKDIR /app
COPY WebApplication/. WebApplication/
WORKDIR /app/WebApplication
RUN dotnet build
RUN dotnet publish -c release -o out

# copy build artifacts into runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
EXPOSE 5000/tcp
ENV ASPNETCORE_URLS http://*:5000
WORKDIR /app
COPY --from=build /app/WebApplication/out ./
ENTRYPOINT ["dotnet", "WebApplication.dll"]