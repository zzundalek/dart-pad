# ZodArt - DartPad

This is a fork of the original [dart-pad](https://github.com/dart-lang/dart-pad), created to showcase the [ZodArt package](https://pub.dev/packages/zodart).

DartPad is a free, open-source online editor to help developers learn about Dart
and Flutter. You can access it at [dartpad.dev](http://dartpad.dev).

# Adding a sample

1. Add the sample code to [pkgs/samples/lib](./pkgs/samples/lib/)
1. Update the [pkgs/samples/lib/samples.json](./pkgs/samples/lib/samples.json)
1. Generate the sample file by running:

    ```shell
    cd pkgs/samples
    dart tool/samples.dart
    ```

# Running locally

## FE

```shell
cd pkgs/dartpad_ui
flutter run -d chrome --web-port 8888 --web-browser-flag "--disable-web-security" \
      --web-launch-url "http://localhost:8888/?channel=localhost&sample=zodart"
```

## BE

> To update packages on BE run: \
> `dart tool/grind.dart build-project-templates` \
> `dart tool/grind.dart build-storage-artifacts`

```shell
cd pkgs/dart_services
FLUTTER_ROOT="~/fvm/versions/3.35.1" dart  bin/server.dart
```

# Embedding

More on: https://github.com/dart-lang/dart-pad/wiki/Sharing-Guide

`http://localhost:8888/?channel=localhost&sample=zodart&embed=true&run=true`

`http://localhost:8888/?id=5c0e154dd50af4a9ac856908061291bc&channel=localhost&embed=true&run=true`


# Building

# BUILD:

docker buildx build \
  --platform linux/amd64 \
  --build-arg BUILD_SHA=$(git rev-parse --short HEAD) \
  -f pkgs/dart_services/Dockerfile \
  -t gcr.io/zodart-pad/zodart-pad:latest .

# INSPECT:

docker run --rm -it -p 8080:8080 --entrypoint /bin/sh gcr.io/zodart-pad/zodart-pad:latest

# RUN

docker run --rm -it -p 8080:8080 gcr.io/zodart-pad/zodart-pad:latest


## License

You can view the license
[here](https://github.com/dart-lang/dart-pad/blob/main/LICENSE).


### TODO

```shell
docker build \
  --build-arg BUILD_SHA=$(git rev-parse --short HEAD) \
  -t gcr.io/zodart-pad/zodart-pad:latest .

# BUILD:

docker buildx build \
  --platform linux/amd64 \
  --build-arg BUILD_SHA=$(git rev-parse --short HEAD) \
  -f pkgs/dart_services/Dockerfile \
  -t gcr.io/zodart-pad/zodart-pad:latest .

# INSPECT:

docker run --rm -it -p 8080:8080 --entrypoint /bin/sh gcr.io/zodart-pad/zodart-pad:latest

# RUN

docker run --rm -it -p 8080:8080 gcr.io/zodart-pad/zodart-pad:latest

# SHARE artifacts
npx http-server .
```
