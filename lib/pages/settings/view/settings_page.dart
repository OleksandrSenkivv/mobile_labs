import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/pages/settings/cubit/settings_cubit.dart';
import 'package:mobile_labs/pages/settings/cubit/settings_state.dart';
import 'package:mobile_labs/service/mqtt_device_service.dart';
import 'package:mobile_labs/settings_widgets/device_info.dart';
import 'package:mobile_labs/settings_widgets/notification_dialog.dart';
import 'package:mobile_labs/settings_widgets/qr_scanner_dialog.dart';
import 'package:mobile_labs/settings_widgets/serial_editor_dialog.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(MqttDeviceService())..connect(),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            showErrorDialog(context, state.errorMessage!);
            context.read<SettingsCubit>().clearError();
          }

          if (state.expectSerialEditorRequest) {
            context.read<SettingsCubit>().resetSerialEditorFlag();
            showSerialEditorDialog(
              context,
              onSubmitted: (newSerial) {
                context.read<SettingsCubit>().sendSerial(newSerial);
                showSuccessDialog(context, 'Серійник "$newSerial" надіслано');
              },
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Налаштування пристрою')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final statusColor = state.connected ? Colors.green : Colors.red;
                final statusText = state.connected ? 'MQTT зʼєднано' :
                'MQTT не зʼєднано';

                void openQRScanner() {
                  if (!state.connected) {
                    showErrorDialog(context, 'MQTT не підключено');
                    return;
                  }
                  showQRScannerDialog(
                    context,
                    onScanned: (_) => context.read<SettingsCubit>()
                        .sendCredentials(),
                  );
                }

                void requestDeviceInfo() {
                  context.read<SettingsCubit>().requestDeviceInfo();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          state.connected ? Icons.cloud_done : Icons.cloud_off,
                          color: statusColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          statusText,
                          style: TextStyle(fontWeight: FontWeight.bold, color:
                          statusColor,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Сканувати QR'),
                      onPressed: state.connected ? openQRScanner : null,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Отримати дані пристрою'),
                      onPressed: state.connected ? requestDeviceInfo : null,
                    ),
                    if (state.infoLoaded)
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(top: 30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16,
                              horizontal: 20,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Інформація про пристрій',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 12),
                              DeviceInfoTable(serial: state.serial, device:
                              state.deviceId,),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
