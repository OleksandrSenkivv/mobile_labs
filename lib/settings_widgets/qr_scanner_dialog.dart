import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void showQRScannerDialog(
    BuildContext context, {
      required void Function(String) onScanned,
    }) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      content: SizedBox(
        width: 300,
        height: 400,
        child: MobileScanner(
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            final data = barcode.rawValue ?? '';
            Navigator.pop(context);
            onScanned(data);
          },
        ),
      ),
    ),
  );
}
