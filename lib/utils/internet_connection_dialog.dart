import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionDialog extends StatefulWidget {
  const InternetConnectionDialog({super.key});

  @override
  State<InternetConnectionDialog> createState() => _InternetConnectionDialogState();
}

class _InternetConnectionDialogState extends State<InternetConnectionDialog> {
  late StreamSubscription<InternetStatus> _subscription;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();

    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      debugPrint("Connection status ==== ${result}");
      if (result.first == ConnectivityResult.none) {
        _showNoInternetDialog();
      } else {
        _closeDialog();
      }

    });


    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        _showNoInternetDialog();
      } else if (status == InternetStatus.connected) {
        _closeDialog();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _showNoInternetDialog() {
    if (!_isDialogOpen && mounted) {
      setState(() {
        _isDialogOpen = true;
      });

      Get.dialog(
        AlertDialog(
          title:  const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No Internet Connection',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
          content: const Text('Please check your internet settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () async {

              },
            ),
          ],
        ),
        barrierDismissible: false,
      ).then((_) => setState(() {
        _isDialogOpen = false;
      }));
    }
  }

  void _closeDialog() {
    if (_isDialogOpen) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      _isDialogOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
