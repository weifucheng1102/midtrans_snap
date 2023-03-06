## Midtrans Snap

> Unofficial midtrans package. This package only supports the snap token flow.

### Usage

1. Add `midtrans_snap` as a dependency in your pubspec.yaml.

    ```yaml
    dependencies:
      midtrans_snap: latest
    ```

2. Install it

    ```shell
      flutter pub get
    ```

3. And use it

    ```dart
    import 'package:flutter/material.dart';
    import 'package:midtrans_snap/midtrans_snap.dart';
    import 'package:midtrans_snap/models.dart';

    main() => runApp(MaterialApp(
          home: Scaffold(
            body: MidtransSnap(
              mode: MidtransEnvironment.sandbox,
              token: 'SNAP_TOKEN',
              midtransClientKey: 'CLIENT_KEY',
              onPageFinished: (url) {
                print(url);
              },
              onPageStarted: (url) {
                print(url);
              },
              onResponse: (result) {
                print(result.toJson());
              },
            ),
          ),
        ));
    ```
