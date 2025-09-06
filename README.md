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

```shell
cd pkgs/dartpad_ui
flutter run -d chrome --web-port 8888 --web-browser-flag "--disable-web-security" \
      --web-launch-url "http://localhost:8888/?channel=localhost&sample=zodart"
```

## License

You can view the license
[here](https://github.com/dart-lang/dart-pad/blob/main/LICENSE).
