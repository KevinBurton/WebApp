FROM microsoft/aspnetcore-build AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -o out

# Build runtime image
FROM microsoft/aspnetcore
WORKDIR /app
ENV NODE_VERSION 8.9.1
ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
ENV NODE_DOWNLOAD_SHA 0e49da19cdf4c89b52656e858346775af21f1953c308efbc803b665d6069c15c
RUN curl -SL "$NODE_DOWNLOAD_URL" --output nodejs.tar.gz \
    && echo "$NODE_DOWNLOAD_SHA nodejs.tar.gz" | sha256sum -c - \
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "webapp.dll"]
