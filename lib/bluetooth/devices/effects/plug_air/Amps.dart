// (c) 2020-2021 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import 'package:mighty_plug_manager/bluetooth/devices/value_formatters/ValueFormatter.dart';

import '../../NuxConstants.dart';
import '../../NuxMightyPlugAir.dart';
import '../Processor.dart';
import 'Ampsv2.dart';
import 'Cabinet.dart';

abstract class PlugAirAmplifier extends Amplifier {
  int? get nuxEffectTypeIndex => PresetDataIndexPlugAir.amptype;
  int? get nuxEnableIndex => PresetDataIndexPlugAir.ampenable;
  EffectEditorUI get editorUI => EffectEditorUI.Sliders;
  int get midiCCEnableValue => MidiCCValues.bCC_AmpEnable;
  int get midiCCSelectionValue => MidiCCValues.bCC_AmpModeSetup;
  int get defaultCab;
}

class TwinVerb extends PlugAirAmplifier {
  final name = "Twin Verb";

  int get defaultCab => TR212.cabIndex;
  int get nuxIndex => 0;

  bool isSeparator = true;
  String category = "Clean";

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 78,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 80,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Tone",
        handle: "tone",
        value: 68,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];

  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return TwinRvbV2().nuxIndex;
    return nuxIndex;
  }
}

class JZ120 extends PlugAirAmplifier {
  final name = "JZ 120";

  int get nuxIndex => 1;
  int get defaultCab => JZ120IR.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 76,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 75,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 62,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Tone",
        handle: "tone",
        value: 54,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];

  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return JazzClean().nuxIndex;
    return nuxIndex;
  }
}

class TweedDlx extends PlugAirAmplifier {
  final name = "Tweed Dlx";

  int get nuxIndex => 2;
  int get defaultCab => DR112.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 60,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 92,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 42,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 59,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 66,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Tone",
        handle: "tone",
        value: 49,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];

  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return DeluxeRvb().nuxIndex;
    return nuxIndex;
  }
}

class Plexi extends PlugAirAmplifier {
  final name = "Plexi";

  bool isSeparator = true;
  String category = "Overdrive";

  int get nuxIndex => 3;
  int get defaultCab => GB412.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 26,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 53,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Tone",
        handle: "tone",
        value: 70,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];
  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index)
      return Plexi1987x50().nuxIndex;
    return nuxIndex;
  }
}

class TopBoost extends PlugAirAmplifier {
  final name = "Top Boost 30";

  int get nuxIndex => 4;
  int get defaultCab => A212.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 44,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 81,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 35,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mdl",
        value: 71,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 52,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Tone (Presence)",
        handle: "tone",
        value: 58,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];

  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return ClassA30().nuxIndex;
    return nuxIndex;
  }
}

class Lead100 extends PlugAirAmplifier {
  final name = "Lead 100";

  int get nuxIndex => 5;
  int get defaultCab => BS410.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 71,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 66,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 60,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "middle",
        value: 62,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 53,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Tone (Presence)",
        handle: "tone",
        value: 67,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];
  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return Brit800().nuxIndex;
    return nuxIndex;
  }
}

class Fireman extends PlugAirAmplifier {
  final name = "Fireman";

  bool isSeparator = true;
  String category = "Distortion";

  int get nuxIndex => 6;
  int get defaultCab => V412.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 54,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 69,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Tone",
        handle: "tone",
        value: 53,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];
}

class DIEVH4 extends PlugAirAmplifier {
  final name = "DIE VH4";

  int get nuxIndex => 7;
  int get defaultCab => V412.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 68,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 72,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 41,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 64,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 55,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Tone (Presence)",
        handle: "tone",
        value: 51,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];
  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return DIEVH4v2().nuxIndex;
    return nuxIndex;
  }
}

class Recto extends PlugAirAmplifier {
  final name = "Recto";

  int get nuxIndex => 8;
  int get defaultCab => V412.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 73,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 60,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 69,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 35,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 46,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Tone (Presence)",
        handle: "tone",
        value: 63,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];

  //this is used for version transition
  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return DualRect().nuxIndex;
    return nuxIndex;
  }
}

class Optima extends PlugAirAmplifier {
  final name = "Optima";

  bool isSeparator = true;
  String category = "Acoustic";

  int get nuxIndex => 9;
  int get defaultCab => MD45.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 72,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 100,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
  ];
  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return Stagemanv2().nuxIndex;
    return nuxIndex;
  }
}

class Stageman extends PlugAirAmplifier {
  final name = "Stageman";

  int get nuxIndex => 10;
  int get defaultCab => MD45.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 60,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 90,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
  ];

  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return Stagemanv2().nuxIndex;
    return nuxIndex;
  }
}

class MLD extends PlugAirAmplifier {
  final name = "MLD";

  bool isSeparator = true;
  String category = "Bass";

  int get nuxIndex => 11;
  int get defaultCab => TRC410.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 70,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 91,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 59,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 61,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Mid Freq",
        handle: "mid_freq",
        value: 63,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];

  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return MLDv2().nuxIndex;
    return nuxIndex;
  }
}

class AGL extends PlugAirAmplifier {
  final name = "AGL";

  int get nuxIndex => 12;
  int get defaultCab => AGLDB810.cabIndex;

  @override
  List<Parameter> parameters = [
    Parameter(
        name: "Gain",
        handle: "gain",
        value: 61,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampgain,
        midiCC: MidiCCValues.bCC_AmpDrive),
    Parameter(
        name: "Level",
        handle: "level",
        value: 89,
        formatter: ValueFormatters.percentage,
        masterVolume: true,
        devicePresetIndex: PresetDataIndexPlugAir.amplevel,
        midiCC: MidiCCValues.bCC_AmpMaster),
    Parameter(
        name: "Bass",
        handle: "bass",
        value: 72,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampbass,
        midiCC: MidiCCValues.bCC_OverDriveDrive),
    Parameter(
        name: "Middle",
        handle: "mid",
        value: 50,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.ampmiddle,
        midiCC: MidiCCValues.bCC_OverDriveTone),
    Parameter(
        name: "Treble",
        handle: "treble",
        value: 63,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptreble,
        midiCC: MidiCCValues.bCC_OverDriveLevel),
    Parameter(
        name: "Mid Freq",
        handle: "mid_freq",
        value: 63,
        formatter: ValueFormatters.percentage,
        devicePresetIndex: PresetDataIndexPlugAir.amptone, //check this
        midiCC: MidiCCValues.bCC_AmpPresence),
  ];
  int? getEquivalentEffect(int version) {
    if (version == PlugAirVersion.PlugAir21.index) return AGLv2().nuxIndex;
    return nuxIndex;
  }
}
