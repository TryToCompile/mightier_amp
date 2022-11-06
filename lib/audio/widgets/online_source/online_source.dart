// (c) 2020 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)
//

import 'package:flutter/material.dart';
import 'package:mighty_plug_manager/audio/online_sources/backingTracksCoSource.dart';
import 'package:mighty_plug_manager/audio/online_sources/guitarBackingTracksSource.dart';

import 'search_screen.dart';

class OnlineSourceSearch extends StatefulWidget {
  @override
  _OnlineSourceSearchState createState() => _OnlineSourceSearchState();
}

class _OnlineSourceSearchState extends State<OnlineSourceSearch> {
  int refreshTime = 1;
  String path = "";

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    editingController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Online Sources")),
        body: ListView(
          children: [
            ListTile(
                leading: const Icon(Icons.cloud),
                onTap: () async {
                  var result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => OnlineSearchScreen(
                              source: GuitarBackingTracksSource())));
                  if (result != null) Navigator.of(context).pop(result);
                },
                title: const Text("guitarbackingtracks.com"),
                trailing: const Icon(Icons.keyboard_arrow_right)),
            ListTile(
                leading: const Icon(Icons.cloud),
                onTap: () async {
                  var result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => OnlineSearchScreen(
                              source: BackingTracksCoSource())));
                  if (result != null) Navigator.of(context).pop(result);
                },
                title: const Text("backingtracks.co"),
                trailing: const Icon(Icons.keyboard_arrow_right))
          ],
        ));
  }
}
