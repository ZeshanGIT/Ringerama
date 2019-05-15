import 'dart:io';

import 'package:demo/pages/pickFromDirectory.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:demo/constants.dart';
import 'package:flutter/widgets.dart';

class MyDirectoryPicker extends StatefulWidget {
  final double spacing;
  final List<Directory> list;
  final double itemHeight;
  final List<Song> songs;

  MyDirectoryPicker({this.spacing, this.list, this.itemHeight, this.songs});

  @override
  _MyDirectoryPickerState createState() => _MyDirectoryPickerState();
}

class _MyDirectoryPickerState extends State<MyDirectoryPicker> {
  List<Directory> folders, selectedFolders = List<Directory>();

  @override
  void initState() {
    folders = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double s = widget.spacing / 2;
    folders = folders.toSet().toList();
    print(selectedFolders);
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text("Add ringtones"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context, selectedFolders);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(s, s, s, 0),
        child: ListView.builder(
          itemCount: folders.length,
          itemBuilder: (bc, i) {
            return GestureDetector(
                onTap: () {
                  if (selectedFolders.contains(folders[i])) {
                    setState(() {
                      selectedFolders.remove(folders[i]);
                    });
                  } else {
                    setState(() {
                      selectedFolders.add(folders[i]);
                    });
                  }
                },
                child: Card(
                  color: selectedFolders.contains(folders[i])
                      ? secondaryColor
                      : Colors.black,
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        height: widget.itemHeight,
                        child: Container(
                          padding: EdgeInsets.only(left: widget.spacing),
                          child: buildText(i),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        highlightColor: secondaryColor,
                        color: !selectedFolders.contains(folders[i])
                            ? secondaryColor
                            : Colors.black,
                        icon: Icon(Icons.navigate_next),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (bc) => PickFromDirectory(
                                  selectedFolders.contains(folders[i]),
                                  folders[i].uri.pathSegments[
                                      folders[i].uri.pathSegments.length - 2],
                                  folders[i],
                                  widget.songs,
                                  s,
                                  widget.itemHeight,
                                  widget.spacing),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget buildText(int i) {
    int k = folders[i].uri.pathSegments.length - 2;
    return Text(
      folders[i].uri.pathSegments[k],
      style: TextStyle(
        color:
            !selectedFolders.contains(folders[i]) ? Colors.white : Colors.black,
        fontSize: widget.spacing,
      ),
    );
  }
}
