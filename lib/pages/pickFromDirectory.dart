import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PickFromDirectory extends StatefulWidget {
  bool isSelected;
  String directory;
  Directory rings;
  List<Song> allSongs;
  double s;

  double itemHeight;

  double spacing;
  PickFromDirectory(this.isSelected, this.directory, this.rings, this.allSongs,
      this.s, this.itemHeight, this.spacing);
  @override
  _PickFromDirectoryState createState() => _PickFromDirectoryState();
}

class _PickFromDirectoryState extends State<PickFromDirectory> {
  List<Song> allSongs;
  List<Song> songsInDir;

  @override
  Widget build(BuildContext context) {
    // print("Item height: ${widget.itemHeight}");
    allSongs = widget.allSongs;
    songsInDir = allSongs.where((test) {
      String d = File(test.uri).parent.toString();
      String k = widget.rings.toString();
      print("D: $d");
      print("K: $k");
      return d == k;
    }).toList();
    // selectedSongs.add(songsInDir[0]);
    print("Rings : ${widget.rings}");
    print("All Songs: ${allSongs.map((f) => File(f.uri).parent).toList()}");
    print("Songs in dir: $songsInDir");
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.directory,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(widget.s, widget.s, widget.s, 0),
        child: ListView.builder(
            itemCount: songsInDir.length + 1,
            itemBuilder: (bc, i) => i == 0
                ? Container(
                    padding: EdgeInsets.all(widget.s),
                    child: Text(
                      "${songsInDir.length} songs",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: widget.s * 2,
                      ),
                    ),
                  )
                : Card(
                    color: Colors.black,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: widget.itemHeight,
                      child: Container(
                        padding: EdgeInsets.only(left: widget.spacing),
                        child: Text(
                          songsInDir[i - 1].title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.spacing,
                          ),
                        ),
                      ),
                    ),
                  )),
      ),
    );
  }
}
