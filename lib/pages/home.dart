import 'dart:collection';
import 'dart:io';

import 'package:demo/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'myPicker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum Cycle { MINUTES, HOURS, DAYS }

class _HomeState extends State<Home> {
  PageController pageController = new PageController(initialPage: 0);
  int currTab = 0;
  Cycle cycle = Cycle.MINUTES;
  int interval = 10;

  double seekTime = 0;

  bool addFlag = false;
  bool addFlag2 = false;

  List<Song> ringtones = List<Song>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: currTab,
        backgroundColor: primaryColor,
        onTap: (i) => setState(() {
              pageController.animateToPage(i,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              currTab = i;
            }),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            title: Text("Playlist"),
          ),
        ],
      ),
      backgroundColor: primaryDark,
      appBar: AppBar(
        actions: currTab == 1
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.spa),
                  onPressed: () {},
                ),
              ]
            : null,
        backgroundColor: primaryColor,
        title: Text("Ringerama"),
      ),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[buildHome(), buildPlaylist()],
      ),
    );
  }

  LayoutBuilder buildPlaylist() {
    return LayoutBuilder(
      builder: (build, bcon) {
        double k = bcon.maxHeight * 0.02;
        return Padding(
          padding: EdgeInsets.fromLTRB(k, k, k, 0),
          child: LayoutBuilder(
            builder: (bc, c) {
              double itemHeight = c.maxHeight / 8;
              if (itemHeight > 70) itemHeight = 70;
              double spacing = c.maxHeight / 24;
              // double w = c.maxWidth;
              return Stack(
                children: <Widget>[
                  Positioned(
                    child: ListView.builder(
                      itemCount: ringtones.length,
                      itemBuilder: (bc, i) => Card(
                            color: Colors.black,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: itemHeight,
                              child: Container(
                                padding: EdgeInsets.only(left: spacing),
                                child: Text(
                                  ringtones.map((f) => f.title).toList()[i],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: spacing,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                  buildAddButton(spacing, itemHeight),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildAddButton(double spacing, double itemHeight) {
    double s = spacing / 2;
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(milliseconds: 150),
            opacity: addFlag ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: addFolder,
              child: addFlag2
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                      ),
                      padding: EdgeInsets.all(s),
                      margin: EdgeInsets.only(bottom: spacing / 2),
                      child: Icon(
                        Icons.folder,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ),
          ),
          SizedBox(width: s),
          AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            opacity: addFlag ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: () => addMusic(spacing, itemHeight),
              child: addFlag2
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                      ),
                      padding: EdgeInsets.all(s),
                      margin: EdgeInsets.only(bottom: spacing / 2),
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ),
          ),
          SizedBox(width: s),
          Container(
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.all(s),
            margin: EdgeInsets.only(bottom: s),
            child: GestureDetector(
              onTap: () async {
                if (!addFlag) {
                  setState(() {
                    addFlag2 = true;
                    addFlag = true;
                  });
                } else {
                  setState(() {
                    addFlag = false;
                  });
                  Future.delayed(Duration(milliseconds: 150),
                      () => setState(() => addFlag2 = false));
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(width: spacing / 4),
                  Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: spacing / 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LayoutBuilder buildHome() {
    return LayoutBuilder(
      builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
        double k = boxConstraints.maxHeight * 0.075;
        return Container(
          margin: EdgeInsets.fromLTRB(k, k, k, 0),
          child: LayoutBuilder(
            builder: (bc, c) {
              double itemHeight = c.maxHeight / 6;
              double spacing = c.maxHeight / 24;
              double w = c.maxWidth;
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        buildCurrentRing(w, itemHeight, spacing / 1.5),
                        SizedBox(height: spacing),
                        buildNextRing(w, itemHeight, spacing / 1.5),
                        SizedBox(height: spacing),
                        buildSelectCycle(w, itemHeight, spacing),
                        SizedBox(height: spacing),
                        buildPlayingNow(w, itemHeight, spacing / 1.5),
                        SizedBox(height: spacing),
                        buildPlayerControls(w, itemHeight, spacing),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildPlayingNow(double w, double itemHeight, double spacing) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[
        Colors.black,
        Colors.black,
        Colors.white,
        Colors.white,
      ],
      stops: [
        0,
        (w + seekTime + spacing * 3.2) / w,
        (w + seekTime + spacing * 3.2) / w,
        1.0,
      ],
    ).createShader(Rect.fromLTWH(0.0, 0.0, w, itemHeight));
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails dud) {
          double temp = seekTime + dud.delta.dx;
          if ((w + temp >= 0) & (w + temp <= w))
            setState(() {
              seekTime = temp;
            });
        },
        child: Container(
          width: w,
          height: itemHeight,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(spacing / 8),
                width: w + seekTime,
                height: itemHeight,
                color: secondaryColor,
                child: Text(
                  ((w + seekTime) / w).toString().substring(0, 3),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(spacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Playing Now",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: spacing / 2),
                    Text(
                      "Vaaya en veera",
                      style: TextStyle(
                          fontSize: itemHeight * 0.3,
                          foreground: Paint()..shader = linearGradient),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSelectCycle(double w, double itemHeight, double spacing) {
    return Container(
      width: w,
      height: itemHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildCycle(spacing, itemHeight, w),
          SizedBox(width: spacing),
          buildInterval(spacing, itemHeight, w),
        ],
      ),
    );
  }

  Container buildInterval(double spacing, double itemHeight, double w) {
    List<DropdownMenuItem<int>> intervalList;

    switch (cycle) {
      case Cycle.MINUTES:
        if (interval % 10 != 0) interval += 10 - interval % 10;
        intervalList = List.generate(5, (i) {
          return (i + 1) * 10;
        }).map((f) {
          return DropdownMenuItem<int>(
            value: f,
            child: Text(
              f.toString(),
              style: TextStyle(color: Colors.white),
            ),
          );
        }).toList();
        break;
      case Cycle.HOURS:
        if (interval > 23) interval = 23;
        intervalList = List.generate(24, (i) {
          return i + 1;
        }).map((f) {
          return DropdownMenuItem<int>(
            value: f,
            child: Text(
              f.toString(),
              style: TextStyle(color: Colors.white),
            ),
          );
        }).toList();
        break;
      case Cycle.DAYS:
        if (interval > 15) interval = 15;
        intervalList = List.generate(15, (i) {
          return i + 1;
        }).map((f) {
          return DropdownMenuItem<int>(
            value: f,
            child: Text(
              f.toString(),
              style: TextStyle(color: Colors.white),
            ),
          );
        }).toList();
        break;
    }

    return Container(
      padding: EdgeInsets.all(spacing / 1.5),
      height: itemHeight,
      width: w / 2 - spacing / 2,
      decoration: buildBoxDecoration(Colors.black),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Interval", style: TextStyle(color: Colors.white54)),
          SizedBox(height: spacing / 2),
          Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.black),
            child: DropdownButton<int>(
              isDense: true,
              value: interval,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  interval = value;
                });
              },
              items: intervalList,
            ),
          ),
        ],
      ),
    );
  }

  Container buildCycle(double spacing, double itemHeight, double w) {
    return Container(
      padding: EdgeInsets.all(spacing / 1.5),
      height: itemHeight,
      width: w / 2 - spacing / 2,
      decoration: buildBoxDecoration(Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Cycle", style: TextStyle(color: Colors.white54)),
          SizedBox(height: spacing / 2),
          Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.black),
            child: DropdownButton<Cycle>(
              isDense: true,
              value: cycle,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  cycle = value;
                });
              },
              items: Cycle.values.toList().map((Cycle value) {
                String cycleString = "Minutes";
                switch (value) {
                  case Cycle.MINUTES:
                    cycleString = "Minutes";
                    break;
                  case Cycle.HOURS:
                    cycleString = "Hours";
                    break;
                  case Cycle.DAYS:
                    cycleString = "Days";
                    break;
                }
                return DropdownMenuItem<Cycle>(
                  value: value,
                  child: Text(cycleString,
                      style: TextStyle(
                        color: Colors.white,
                      )),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildNextRing(double w, double itemHeight, double spacing) {
    return Container(
      width: w,
      height: itemHeight,
      padding: EdgeInsets.all(spacing),
      decoration: buildBoxDecoration(Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Next Ringtone", style: TextStyle(color: Colors.white70)),
          SizedBox(height: spacing / 2),
          Text(
            "Malargale Malargale",
            style: TextStyle(fontSize: itemHeight * 0.3, color: Colors.white),
          )
        ],
      ),
    );
  }

  Container buildCurrentRing(double w, double itemHeight, double spacing) {
    return Container(
      padding: EdgeInsets.all(spacing),
      width: w,
      height: itemHeight,
      decoration: buildBoxDecoration(Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Current Ringtone", style: TextStyle(color: Colors.black54)),
          SizedBox(height: spacing / 2),
          Text(
            "Kannathil Muthamittal",
            style: TextStyle(fontSize: itemHeight * 0.3),
          )
        ],
      ),
    );
  }

  Container buildPlayerControls(double w, double itemHeight, double spacing) {
    return Container(
      width: w,
      height: itemHeight,
      decoration: buildBoxDecoration(Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: secondaryColor,
            ),
            onPressed: () {},
            iconSize: itemHeight * 0.5,
          ),
          SizedBox(width: spacing),
          IconButton(
            icon: Icon(
              Icons.play_circle_filled,
              color: secondaryColor,
            ),
            onPressed: () {},
            iconSize: itemHeight * 0.75,
          ),
          SizedBox(width: spacing),
          IconButton(
            icon: Icon(
              Icons.skip_next,
              color: secondaryColor,
            ),
            onPressed: () {},
            iconSize: itemHeight * 0.5,
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    );
  }

  addFolder() async {
    List<Song> list = await MusicFinder.allSongs();
    List<String> albums = list.map((f) => f.album).toList();
    Map<String, List<Song>> albumSong = new HashMap<String, List<Song>>();
    for (String album in albums) {
      albumSong.putIfAbsent(
          album, () => list.where((song) => song.album == album).toList());
    }

    print(albumSong);

    List<String> folders =
        list.map((f) => File(f.uri).parent.toString()).toList();
    Map<String, List<Song>> folderSong = new HashMap<String, List<Song>>();
    for (String folder in folders) {
      folderSong.putIfAbsent(
          folder,
          () => list
              .where((song) => File(song.uri).parent.toString() == folder)
              .toList());
    }

    print(folderSong);
  }

  addMusic(double spacing, double itemHeight) async {
    List<Song> list = await MusicFinder.allSongs();
    List<String> albums = list.map((f) => f.album).toList();
    Map<String, List<Song>> albumSong = new HashMap<String, List<Song>>();
    for (String album in albums) {
      albumSong.putIfAbsent(
          album, () => list.where((song) => song.album == album).toList());
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (bc) => MyPicker(
                  spacing: spacing,
                  list: albumSong,
                  itemHeight: itemHeight,
                ))).then((val) {
      setState(() {
        ringtones = val;
      });
    });
  }
}
