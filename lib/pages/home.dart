import 'package:demo/constants.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum Cycle { MINUTES, HOURS, DAYS }

class _HomeState extends State<Home> {
  int currTab = 0;
  Cycle cycle = Cycle.MINUTES;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: currTab,
        backgroundColor: primaryColor,
        onTap: (i) => setState(() {
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
        backgroundColor: primaryColor,
        title: Text("Ringerama"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
          return Container(
            margin: EdgeInsets.all(boxConstraints.maxHeight * 0.075),
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
      ),
    );
  }

  Container buildPlayingNow(double w, double itemHeight, double spacing) {
    return Container(
      width: w,
      height: itemHeight,
      decoration: buildBoxDecoration(Colors.black),
    );
  }

  Container buildSelectCycle(double w, double itemHeight, double spacing) {
    return Container(
      width: w,
      height: itemHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
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
                DropdownButton<Cycle>(
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
              ],
            ),
          ),
          SizedBox(width: spacing),
          Container(
            height: itemHeight,
            width: w / 2 - spacing / 2,
            decoration: buildBoxDecoration(Colors.black),
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
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Next Ringtone", style: TextStyle(color: Colors.white70)),
              SizedBox(height: spacing / 2),
              Text(
                "Malargale Malargale",
                style:
                    TextStyle(fontSize: itemHeight * 0.3, color: Colors.white),
              )
            ],
          ),
          Expanded(child: Container()),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline),
          ),
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
      child: Row(
        children: <Widget>[
          Column(
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
          Expanded(child: Container()),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline),
          ),
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
}
