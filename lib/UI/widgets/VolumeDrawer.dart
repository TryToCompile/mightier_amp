import 'package:flutter/material.dart';
import 'package:mighty_plug_manager/bluetooth/devices/value_formatters/ValueFormatter.dart';

import '../../bluetooth/NuxDeviceControl.dart';
import '../../platform/simpleSharedPrefs.dart';
import 'thickSlider.dart';

const _kBottomDrawerPickHeight = 50.0;
const _kBottomDrawerHiddenHeight = 60.0;
const _kBottomDrawerHiddenPadding = 8.0;

class BottomDrawer extends StatelessWidget {
  final bool isBottomDrawerOpen;
  final Function(bool) onExpandChange;
  final Widget child;

  const BottomDrawer({
    Key? key,
    required this.isBottomDrawerOpen,
    required this.onExpandChange,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onExpandChange(!isBottomDrawerOpen);
      },
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -5) {
          //open
          onExpandChange(true);
        } else if (details.delta.dy > 5) {
          //close
          onExpandChange(false);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _kBottomDrawerPickHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Icon(
              isBottomDrawerOpen
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              size: 24,
              color: Colors.grey,
            ),
          ),
          AnimatedContainer(
            padding: const EdgeInsets.all(_kBottomDrawerHiddenPadding),
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            duration: const Duration(milliseconds: 100),
            height: isBottomDrawerOpen ? _kBottomDrawerHiddenHeight : 0,
            child: child,
          ),
        ],
      ),
    );
  }
}

class VolumeSlider extends StatelessWidget {
  final void Function() onVolumeChanged;
  final double currentVolume;
  final ValueFormatter volumeFormatter;
  final String label;
  const VolumeSlider(
      {Key? key,
      required this.onVolumeChanged,
      required this.currentVolume,
      required this.volumeFormatter,
      this.label = "Volume"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThickSlider(
      activeColor: Colors.blue,
      value: currentVolume,
      skipEmitting: 3,
      label: label,
      labelFormatter: volumeFormatter.toLabel,
      min: volumeFormatter.min.toDouble(),
      max: volumeFormatter.max.toDouble(),
      handleVerticalDrag: false,
      onChanged: _onVolumeChanged,
      onDragEnd: _onVolumeDragEnd,
    );
  }

  void _onVolumeDragEnd(_) {
    if (NuxDeviceControl.instance().device.fakeMasterVolume) {
      SharedPrefs().setValue(
        SettingsKeys.masterVolume,
        NuxDeviceControl.instance().masterVolume,
      );
    }
  }

  void _onVolumeChanged(value, bool skip) {
    final device = NuxDeviceControl.instance().device;
    if (device.fakeMasterVolume) {
      NuxDeviceControl.instance().masterVolume = value;
    } else {
      device.presets[device.selectedChannel].volume = value;
    }
    NuxDeviceControl.instance().forceNotifyListeners();
    onVolumeChanged.call();
  }
}
