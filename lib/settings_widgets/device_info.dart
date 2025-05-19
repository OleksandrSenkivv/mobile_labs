import 'package:flutter/material.dart';

class DeviceInfoTable extends StatelessWidget {
  final String? serial;
  final String? device;

  const DeviceInfoTable({
    required this.serial,
    required this.device,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(2),
          },
          children: [
            _row('Серійний номер', serial ?? '-'),
            _row('Імʼя пристрою', device ?? '-'),
          ],
        ),
      ],
    );
  }

  TableRow _row(String label, String value) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text(label)),
        Padding(padding: const EdgeInsets.all(8), child: Text(value)),
      ],
    );
  }
}
