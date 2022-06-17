import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mac_address/mac_address.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _macAddress = 'Unknown';
  String? _ipAddress = "Unknown";

  final NetworkInfo _networkInfo = NetworkInfo();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String macAddress = "Unknown";
    String? ipAddress = "Unknown";

    try {
      if (Platform.isAndroid) {
        try {
          macAddress = await GetMac.macAddress;
        } on PlatformException {
          macAddress = 'Failed to get Device MAC Address.';
        }
        try {
          ipAddress = await _networkInfo.getWifiIP();
        } on PlatformException {
          ipAddress = 'Failed to get Device MAC Address.';
        }
      } else if (Platform.isIOS) {
        ipAddress = "this is a ios device";
        macAddress = "THIIS IS A IOS Device";
      }
    } on PlatformException {
      macAddress = 'Failed to get Device MAC Address.';
      ipAddress = 'Failed to get Device MAC Address.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _macAddress = macAddress;
      _ipAddress = ipAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: initPlatformState,
        ),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child:
              Text('MAC Address : $_macAddress\n Ip Address: $_ipAddress \n'),
        ),
      ),
    );
  }
}
