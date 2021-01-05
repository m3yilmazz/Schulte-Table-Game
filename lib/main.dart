import 'dart:async';
import 'package:schulte_table/reactionMode.dart';
import 'package:schulte_table/resultPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'classicLightMode.dart';
import 'classicLightReverseMode.dart';
import 'classicOriginalMode.dart';
import 'classicOriginalReverseMode.dart';
import 'memoryMode.dart';

const int MAX_ELEMENT_NUMBER = 25;

List<int> timePassedToFindNumbers = [0];
List<int> listUsedForRandomAssignment = [];
List<int> sequenceControllerList = [];
int globalTimer = 0;
int bestTimeReaction = 0,
    bestTimeClassicLight = 0,
    bestTimeClassicLightReverse = 0,
    bestTimeClassicOriginal = 0,
    bestTimeClassicOriginalReverse = 0,
    bestTimeMemory = 0;

bool hasRoundFinished = false;

void main() {
  listMaker();

  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => HomeRoute(),
      "/reactionModePlayButton": (context) => PlayButton("Reaction Mode", "/reactionMode", bestTimeReaction),
      "/reactionMode": (context) => ReactionMode(),
      "/classicLightModePlayButton": (context) => PlayButton("Classic Light Mode", "/classicLightMode", bestTimeClassicLight),
      "/classicLightMode": (context) => ClassicLightMode(),
      "/classicLightReverseModePlayButton": (context) => PlayButton("Classic Light Reverse Mode", "/classicLightReverseMode", bestTimeClassicLightReverse),
      "/classicLightReverseMode": (context) => ClassicLightReverseMode(),
      "/classicOriginalModePlayButton": (context) => PlayButton("Classic Original Mode", "/classicOriginalMode", bestTimeClassicOriginal),
      "/classicOriginalMode": (context) => ClassicOriginalMode(),
      "/classicOriginalReverseModePlayButton": (context) => PlayButton("Classic Original Reverse Mode", "/classicOriginalReverseMode", bestTimeClassicOriginalReverse),
      "/classicOriginalReverseMode": (context) => ClassicOriginalReverseMode(),
      "/memoryModePlayButton": (context) => PlayButton("Memory Mode", "/memoryMode", bestTimeMemory),
      "/memoryMode": (context) => MemoryMode(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schulte Table"),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: <Widget>[
          FlatButton(
            child: Text("Reaction"),
            onPressed: () =>
                Navigator.pushNamed(context, "/reactionModePlayButton"),
            color: Colors.blueAccent,
            textColor: Colors.white,
          ),
          FlatButton(
            child: Text("Classic Light"),
            onPressed: () =>
                Navigator.pushNamed(context, "/classicLightModePlayButton"),
            color: Colors.blueAccent,
            textColor: Colors.white,
          ),
          FlatButton(
            child: Text("Classic Light Reverse"),
            onPressed: () => Navigator.pushNamed(
                context, "/classicLightReverseModePlayButton"),
            color: Colors.blueAccent,
            textColor: Colors.white,
          ),
          FlatButton(
            child: Text("Classic Original"),
            onPressed: () =>
                Navigator.pushNamed(context, "/classicOriginalModePlayButton"),
            color: Colors.blueAccent,
            textColor: Colors.white,
          ),
          FlatButton(
            child: Text(
              "Classic Original Reverse",
              textAlign: TextAlign.center,
            ),
            onPressed: () => Navigator.pushNamed(
                context, "/classicOriginalReverseModePlayButton"),
            color: Colors.blueAccent,
            textColor: Colors.white,
          ),
          FlatButton(
            child: Text("Memory"),
            onPressed: () =>
                Navigator.pushNamed(context, "/memoryModePlayButton"),
            color: Colors.blueAccent,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  PlayButton(String gameModeName, String routeName, int bestTime) {
    this.gameModeName = gameModeName;
    this.routeName = routeName;
    this.bestTime = bestTime;
  }
  String gameModeName, routeName;
  int bestTime;
  @override
  State<StatefulWidget> createState() {
    return new PlayButtonState(
        this.gameModeName, this.routeName, this.bestTime);
  }
}

class PlayButtonState extends State<PlayButton> {
  PlayButtonState(String gameModeName, String routeName, int bestTime) {
    this.gameModeName = gameModeName;
    this.routeName = routeName;
    this.bestTime = bestTime;
  }
  String gameModeName, routeName;
  int bestTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title: Text("Play $gameModeName"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Best Time: ${this.bestTime / 1000} second(s)"),
            FlatButton(
              child: Text("Play!"),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () => Navigator.pushNamed(context, routeName),
            ),
          ],
        ),
      ),
    );
  }
}

class ReactionMode extends StatefulWidget {
  ReactionMode({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new ReactionModeState();
  }
}

class ReactionModeState extends State<ReactionMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: Text("Reaction Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: EdgeInsets.all(10), child: Text("Mode: Reaction")),
            Container(
                width: 100,
                padding: EdgeInsets.all(10),
                child: TimerManagement("bestTimeReaction", "Reaction Mode",
                    timePassedToFindNumbers, "/reactionMode", false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  MAX_ELEMENT_NUMBER,
                  (index) => ReactionModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicLightMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new ClassicLightModeState();
  }
}

class ClassicLightModeState extends State<ClassicLightMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: Text("Classic Light Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Mode: Classic Light")),
            Container(
                width: 100,
                padding: EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicLight",
                    "Classic Light Mode",
                    timePassedToFindNumbers,
                    "/classicLightMode",
                    false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  MAX_ELEMENT_NUMBER,
                  (index) => ClassicLightModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicLightReverseMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new ClassicLightReverseModeState();
  }
}

class ClassicLightReverseModeState extends State<ClassicLightReverseMode> {
  int internalNumberTracker = 25;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: Text("Classic Light Reverse Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Mode: Classic Light Reverse")),
            Container(
                width: 100,
                padding: EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicLightReverse",
                    "Classic Light Reverse Mode",
                    timePassedToFindNumbers,
                    "/classicLightReverseMode",
                    true)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  MAX_ELEMENT_NUMBER,
                  (index) => ClassicLightReverseModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicOriginalMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new ClassicOriginalModeState();
  }
}

class ClassicOriginalModeState extends State<ClassicOriginalMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: Text("Classic Original Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Mode: Classic Original")),
            Container(
                width: 100,
                padding: EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicOriginal",
                    "Classic Original Mode",
                    timePassedToFindNumbers,
                    "/classicOriginalMode",
                    false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  MAX_ELEMENT_NUMBER,
                  (index) => ClassicOriginalModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicOriginalReverseMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new ClassicOriginalReverseModeState();
  }
}

class ClassicOriginalReverseModeState extends State<ClassicOriginalReverseMode> {
  int internalNumberTracker = 25;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: Text("Classic Original Reverse Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Mode: Classic Original Reverse",
                  style: TextStyle(fontSize: 12),
                )),
            Container(
                width: 100,
                padding: EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicOriginalReverse",
                    "Classic Original Reverse Mode",
                    timePassedToFindNumbers,
                    "/classicOriginalReverseMode",
                    true)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  MAX_ELEMENT_NUMBER,
                  (index) => ClassicOriginalReverseModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class MemoryMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new MemoryModeState();
  }
}

class MemoryModeState extends State<MemoryMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: Text("Memory Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(padding: EdgeInsets.all(10), child: Text("Mode: Memory")),
            Container(
                width: 100,
                padding: EdgeInsets.all(10),
                child: new TimerManagement("bestTimeMemory", "Memory Mode",
                    timePassedToFindNumbers, "/memoryMode", false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  MAX_ELEMENT_NUMBER,
                  (index) => MemoryModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

void listMaker() {
  listUsedForRandomAssignment.clear();
  sequenceControllerList.clear();
  for (int i = 0; i < MAX_ELEMENT_NUMBER; i++) {
    listUsedForRandomAssignment.add(i + 1);
    sequenceControllerList.add(i + 1);
  }
}

class TimerManagement extends StatefulWidget {
  String bestTimeName;
  List<int> list;
  String previousGameModeRoute, gameModeName;
  bool isReverse;
  TimerManagement(String bestTimeName, String gameModeName, List<int> list,
      String previousGameModeRoute, bool isReverse) {
    this.bestTimeName = bestTimeName;
    this.gameModeName = gameModeName;
    this.list = list;
    this.previousGameModeRoute = previousGameModeRoute;
    this.isReverse = isReverse;
  }
  @override
  _TimerManagementState createState() => _TimerManagementState(
      bestTimeName, gameModeName, list, previousGameModeRoute, isReverse);
}

class _TimerManagementState extends State<TimerManagement> {
  String bestTimeName;
  List<int> list;
  String previousGameModeRoute, gameModeName;
  bool isReverse;
  _TimerManagementState(String bestTimeName, String gameModeName,
      List<int> list, String previousGameModeRoute, bool isReverse) {
    this.bestTimeName = bestTimeName;
    this.gameModeName = gameModeName;
    this.list = list;
    this.previousGameModeRoute = previousGameModeRoute;
    this.isReverse = isReverse;
  }
  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 1), (callBack) {
      setState(() {
        if (hasRoundFinished) {
          callBack.cancel();
        }
        globalTimer += 1;
        if (!hasRoundFinished && globalTimer == 60000) {
          for (int i = this.list.length; i < MAX_ELEMENT_NUMBER; i++) {
            this.list.add(0);
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultPage(
                      this.bestTimeName,
                      this.gameModeName,
                      this.list,
                      this.previousGameModeRoute,
                      this.isReverse)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text((globalTimer / 1000).toStringAsFixed(3));
  }
}
