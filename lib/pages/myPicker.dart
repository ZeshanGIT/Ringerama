import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:demo/constants.dart';
import 'package:flutter/widgets.dart';

class MyPicker extends StatefulWidget {
  final double spacing;
  final Map<String, List<Song>> list;
  final double itemHeight;
  MyPicker({this.spacing, this.list, this.itemHeight});

  @override
  _MyPickerState createState() => _MyPickerState();
}

class _MyPickerState extends State<MyPicker> {
  bool isAlbumMode = false;
  List<String> albums;
  List<Song> selectedSongs = List<Song>();
  List<Song> allSongs = List<Song>();
  // bool isExpanded = true;
  // bool isSelectedAll = false;
  @override
  void initState() {
    albums = widget.list.keys.toList();
    for (String sng in albums) {
      allSongs.addAll(widget.list[sng]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double s = widget.spacing / 2;
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text("Add ringtones"),
        actions: <Widget>[
          // isAlbumMode
          //     ? isExpanded
          //         ? IconButton(
          //             icon: Icon(Icons.list),
          //             onPressed: () {
          //               setState(() {
          //                 isExpanded = false;
          //               });
          //             },
          //           )
          //         : IconButton(
          //             icon: Icon(Icons.line_style),
          //             onPressed: () {
          //               isExpanded = true;
          //             },
          //           )
          //     : isSelectedAll
          //         ? IconButton(
          //             icon: Icon(Icons.playlist_add_check),
          //             onPressed: () {
          //               setState(() {
          //                 selectedSongs.clear();
          //               });
          //             },
          //           )
          //         : IconButton(
          //             icon: Icon(Icons.pool),
          //             onPressed: () {
          //               selectedSongs = allSongs;
          //             },
          //           ),
          IconButton(
            onPressed: () {
              setState(() {
                isAlbumMode = !isAlbumMode;
              });
            },
            icon: isAlbumMode ? Icon(Icons.album) : Icon(Icons.library_music),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context, selectedSongs);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(s, s, s, 0),
        child: isAlbumMode ? buildAlbumView(context, s) : buildSongsView(),
      ),
    );
  }

  ListView buildSongsView() {
    return ListView.builder(
      itemCount: allSongs.length,
      itemBuilder: (bc, i) {
        return GestureDetector(
          onTap: () {
            if (selectedSongs.contains(allSongs[i])) {
              setState(() {
                selectedSongs.remove(allSongs[i]);
              });
            } else {
              setState(() {
                selectedSongs.add(allSongs[i]);
              });
            }
          },
          child: Card(
            color: selectedSongs.contains(allSongs[i])
                ? secondaryColor
                : Colors.black,
            child: Container(
              alignment: Alignment.centerLeft,
              height: widget.itemHeight,
              child: Container(
                padding: EdgeInsets.only(left: widget.spacing),
                child: Text(
                  allSongs[i].title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.spacing,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ListView buildAlbumView(BuildContext context, double s) {
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (bc, i) => Card(
            color: Colors.black,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: secondaryColor),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    children: List.generate(
                      widget.list[albums[i]].length,
                      (k) => InkWell(
                            splashColor: secondaryColor,
                            highlightColor: secondaryColor,
                            onTap: () {
                              if (selectedSongs
                                  .contains(widget.list[albums[i]][k])) {
                                setState(() {
                                  selectedSongs
                                      .remove(widget.list[albums[i]][k]);
                                });
                              } else {
                                setState(() {
                                  selectedSongs.add(
                                    widget.list[albums[i]][k],
                                  );
                                });
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              padding: EdgeInsets.all(s),
                              color: selectedSongs
                                      .contains(widget.list[albums[i]][k])
                                  ? secondaryColor
                                  : Colors.white10,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.list[albums[i]]
                                    .map((f) => f.title)
                                    .toList()[k],
                                style: TextStyle(
                                  fontSize: widget.spacing,
                                  color: selectedSongs
                                          .contains(widget.list[albums[i]][k])
                                      ? Colors.black
                                      : Colors.white70,
                                ),
                              ),
                            ),
                          ),
                    ),
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        albums[i],
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.spacing,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
