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
