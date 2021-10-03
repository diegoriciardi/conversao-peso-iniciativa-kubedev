# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
COPY . .
COPY site.css ./ConversaoPeso.Web/css
COPY bootstrap.min.css ./ConversaoPeso.Web/css
RUN dotnet restore


# copy everything else and build app
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]
