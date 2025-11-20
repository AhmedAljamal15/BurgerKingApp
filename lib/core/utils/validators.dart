import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> onWillPop(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm exit"),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      SystemNavigator.pop(); // Close the app
      return true;
    }

    return false; // Not exiting the page
  }