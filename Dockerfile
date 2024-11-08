FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY . .

RUN dotnet restore ./AnvilCloud.sln

RUN dotnet publish ./AnvilCloud/AnvilCloud.csproj -c Release --framework net8.0 --runtime linux-x64 -o published --no-restore --self-contained

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/published .

ENV PORT 80
EXPOSE 80
ENV ASPNETCORE_URLS "http://*:${PORT}"
ENTRYPOINT [ "dotnet", "AnvilCloud.dll" ]

