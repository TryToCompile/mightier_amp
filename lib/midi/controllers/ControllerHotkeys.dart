import 'package:mighty_plug_manager/bluetooth/NuxDeviceControl.dart';

import '../../bluetooth/devices/NuxDevice.dart';
import '../../bluetooth/devices/NuxFXID.dart';
import '../../bluetooth/devices/effects/MidiControllerHandles.dart';
import '../../bluetooth/devices/effects/Processor.dart';
import '../../bluetooth/devices/utilities/MathEx.dart';
import '../ControllerConstants.dart';

class ControllerHotkey {
  //type of value it controls
  HotkeyControl control;

  //friendly name
  String hotkeyName;

  //code that activates it - either 16 bit midi message or HID code
  int hotkeyCode;

  //main parameter - i.e. channel or slot
  int index;

  //sub parameter - which slider for example
  int subIndex;

  NuxDevice? _cachedDevice;
  int? _cachedSlot;
  int? _cachedFX;
  int? _cachedParameter;

  ControllerHotkey(
      {required this.control,
      required this.index,
      required this.subIndex,
      required this.hotkeyCode,
      required this.hotkeyName});

  execute(int? value) {
    var device = NuxDeviceControl().device;
    int channel = device.selectedChannel;
    switch (control) {
      case HotkeyControl.PreviousChannel:
        do {
          channel--;
          if (channel < 0) channel = device.channelsCount - 1;
        } while (!device.getChannelActive(channel));
        device.setSelectedChannel(channel,
            notifyBT: true, sendFullPreset: false, notifyUI: true);
        device.getPreset(device.selectedChannel).setupPresetFromNuxData();
        break;
      case HotkeyControl.NextChannel:
        do {
          channel++;
          if (channel >= device.channelsCount) channel = 0;
        } while (!device.getChannelActive(channel));
        device.setSelectedChannel(channel,
            notifyBT: true, sendFullPreset: false, notifyUI: true);
        device.getPreset(device.selectedChannel).setupPresetFromNuxData();
        break;
      case HotkeyControl.ChannelByIndex:
        device.setSelectedChannel(channel,
            notifyBT: true, sendFullPreset: false, notifyUI: true);
        device.getPreset(device.selectedChannel).setupPresetFromNuxData();
        break;
      case HotkeyControl.EffectSlotEnable:
        var p = device.getPreset(device.selectedChannel);
        var slot = _findSlotByFunction(control);
        if (slot != null) {
          p.setSlotEnabled(slot, true, true);
          NuxDeviceControl.instance().forceNotifyListeners();
        }
        break;
      case HotkeyControl.EffectSlotDisable:
        var p = device.getPreset(device.selectedChannel);
        var slot = _findSlotByFunction(control);
        if (slot != null) {
          p.setSlotEnabled(slot, false, true);
          NuxDeviceControl.instance().forceNotifyListeners();
        }
        break;
      case HotkeyControl.EffectSlotToggle:
        var p = device.getPreset(device.selectedChannel);
        var slot = _findSlotByFunction(control);
        if (slot != null) {
          p.setSlotEnabled(slot, !p.slotEnabled(slot), true);
          NuxDeviceControl.instance().forceNotifyListeners();
        }
        break;
      case HotkeyControl.EffectDecrement:
        var p = device.getPreset(device.selectedChannel);
        var slot = _findSlotByFunction(control);
        if (slot != null) {
          var effects = p.getEffectsForSlot(slot);
          var effect = p.getSelectedEffectForSlot(slot) - 1;
          if (effect < 0) effect = effects.length - 1;
          p.setSelectedEffectForSlot(slot, effect, true);
          NuxDeviceControl.instance().forceNotifyListeners();
        }
        break;
      case HotkeyControl.EffectIncrement:
        var p = device.getPreset(device.selectedChannel);
        var slot = _findSlotByFunction(control);
        if (slot != null) {
          var effects = p.getEffectsForSlot(slot);
          var effect = p.getSelectedEffectForSlot(slot) + 1;
          if (effect > effects.length - 1) effect = 0;
          p.setSelectedEffectForSlot(slot, effect, true);
          NuxDeviceControl.instance().forceNotifyListeners();
        }
        break;
      case HotkeyControl.ParameterSet:
        if (index >= ControllerHandleId.values.length) return;
        ControllerHandleId id = ControllerHandleId.values[index];

        bool deviceChanged = device != _cachedDevice;
        _cachedDevice = device;

        var p = device.getPreset(device.selectedChannel);

        //find slot and cache it
        if (deviceChanged ||
            _cachedSlot == null ||
            _cachedFX != p.getSelectedEffectForSlot(_cachedSlot!)) {
          _cachedSlot = null;
          _cachedFX = null;
          _cachedParameter = null;
          for (int i = 0; i < device.effectsChainLength; i++) {
            var selectedFX = p.getSelectedEffectForSlot(i);
            var effect = p.getEffectsForSlot(i)[selectedFX];
            var paramIndex = _findParameterByControllerHandleId(effect, id);
            if (paramIndex != null) {
              _cachedSlot = i;
              _cachedFX = selectedFX;
              _cachedParameter = paramIndex;
              break;
            }
          }
        }

        if (_cachedSlot == null || _cachedSlot! >= device.effectsChainLength) {
          return;
        }
        var selectedFX = p.getSelectedEffectForSlot(_cachedSlot!);
        var effect = p.getEffectsForSlot(_cachedSlot!)[selectedFX];

        double val = ((value ?? 0) / 127) * 100;

        //Translate the 0-100 value into the range of the parameter
        val = MathEx.map(
            val,
            0,
            100,
            effect.parameters[_cachedParameter!].formatter.min.toDouble(),
            effect.parameters[_cachedParameter!].formatter.max.toDouble());
        p.setParameterValue(effect.parameters[_cachedParameter!], val);
        NuxDeviceControl.instance().forceNotifyListeners();

        break;
    }
  }

  int? _findSlotByFunction(HotkeyControl func) {
    var device = NuxDeviceControl().device;
    if (index >= ControllerHandleId.values.length) return null;
    ControllerHandleId id = ControllerHandleId.values[index];
    var p = device.getPreset(device.selectedChannel);
    int? slot;
    for (int i = 0; i < device.effectsChainLength; i++) {
      if (func == HotkeyControl.EffectSlotDisable &&
          p.getEffectsForSlot(i)[0].midiControlOff?.id == id) {
        slot = i;
        break;
      } else if (func == HotkeyControl.EffectSlotEnable &&
          p.getEffectsForSlot(i)[0].midiControlOn?.id == id) {
        slot = i;
        break;
      } else if (func == HotkeyControl.EffectSlotToggle &&
          p.getEffectsForSlot(i)[0].midiControlToggle?.id == id) {
        slot = i;
        break;
      } else if (func == HotkeyControl.EffectDecrement &&
          p.getEffectsForSlot(i)[0].midiControlPrev?.id == id) {
        slot = i;
        break;
      } else if (func == HotkeyControl.EffectIncrement &&
          p.getEffectsForSlot(i)[0].midiControlNext?.id == id) {
        slot = i;
        break;
      }
    }
    return slot;
  }

  int? _findParameterByControllerHandleId(
      Processor proc, ControllerHandleId id) {
    for (int i = 0; i < proc.parameters.length; i++) {
      if (proc.parameters[i].midiControllerHandle?.id == id) return i;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data["name"] = hotkeyName;
    data["control"] = control.toString();
    data["code"] = hotkeyCode;
    data["index"] = index;
    data["subIndex"] = subIndex;

    return data;
  }

  factory ControllerHotkey.fromJson(dynamic json) {
    ControllerHotkey hk = ControllerHotkey(
        control: getHKFromString(json["control"]),
        hotkeyCode: json["code"],
        hotkeyName: json["name"],
        index: json["index"],
        subIndex: json["subIndex"]);
    return hk;
  }

  static HotkeyControl getHKFromString(String controlAsString) {
    for (var element in HotkeyControl.values) {
      if (element.toString() == controlAsString) {
        return element;
      }
    }
    throw Exception("Error: Unknown HotkeyControl type!");
  }
}
