# Build Stage
FROM microsoft/aspnetcore-build AS build-env

WORKDIR /WebApp

# Restore
COPY webapp/webapp.csproj ./webapp/
RUN dotnet restore webapp/webapp.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

# Copy source
COPY . .

WORKDIR /WebApp/webapp

RUN npm install

WORKDIR /WebApp

# RUN ls -alR
# -OR-
# docker build -t testing .
# docker run -rm testing ls -alR

# Test (integration with TeamCity)
# need a separate build step https://blog.jetbrains.com/teamcity/2017/04/test-net-core-with-teamcity/
RUN dotnet test tests/tests.csproj

# Publish
RUN dotnet publish webapp/webapp.csproj -o /publish

# Runtime stage
FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish
WORKDIR /publish

ENV NODE_VERSION 8.9.1
ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
ENV NODE_DOWNLOAD_SHA 0e49da19cdf4c89b52656e858346775af21f1953c308efbc803b665d6069c15c
RUN curl -SL "$NODE_DOWNLOAD_URL" --output nodejs.tar.gz \
    && echo "$NODE_DOWNLOAD_SHA nodejs.tar.gz" | sha256sum -c - \
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENTRYPOINT ["dotnet", "api.dll"]

# If the image is pushed you can see the new repository in TeamCity
# my-registry:55000/v2/_catalog
# The tags can be listed as
# my-registry:55000/v2/<repository>/tags/list
