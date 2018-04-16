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

# RUN ls -alR
# -OR-
# docker build -t testing .
# docker run -rm testing ls -alR

# Test
ENV TEAMCITY_PROJECT_NAME=fake
RUN dotnet test tests/tests.csproj

# Publish
RUN dotnet publish webapp/webapp.csproj -o /publish

# Runtime stage
FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT ["dotnet", "api.dll"]

# If the image is pushed you can see the new repository in TeamCity
# my-registry:55000/v2/_catalog
# The tags can be listed as
# my-registry:55000/v2/<repository>/tags/list
