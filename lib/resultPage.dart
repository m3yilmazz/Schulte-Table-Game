import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class ResultPage extends StatelessWidget {
  String bestTimeName;
  List<int> list;
  String previousGameModeRoute, gameModeName;
  bool isReverse;
  ResultPage(String bestTimeName, String gameModeName, List<int> list,
      String previousGameModeRoute, bool isReverse) {
    this.bestTimeName = bestTimeName;
    this.gameModeName = gameModeName;
    this.list = list;
    this.previousGameModeRoute = previousGameModeRoute;
    this.isReverse = isReverse;
  }

  List<String> resultList = new List<String>();

  Widget printTimeSpentToFindNumbers(String bestTimeName, List<int> list) {
    int tempBestTime;
    switch (bestTimeName) {
      case "bestTimeReaction":
        {
          if (hasRoundFinished &&
              (bestTimeReaction == 0 || globalTimer < bestTimeReaction)) {
            bestTimeReaction = globalTimer;
          }
          tempBestTime = bestTimeReaction;
        }
        break;
      case "bestTimeClassicLight":
        {
          if (hasRoundFinished &&
              (bestTimeClassicLight == 0 ||
                  globalTimer < bestTimeClassicLight)) {
            bestTimeClassicLight = globalTimer;
          }
          tempBestTime = bestTimeClassicLight;
        }
        break;
      case "bestTimeClassicLightReverse":
        {
          if (hasRoundFinished &&
              (bestTimeClassicLightReverse == 0 ||
                  globalTimer < bestTimeClassicLightReverse)) {
            bestTimeClassicLightReverse = globalTimer;
          }
          tempBestTime = bestTimeClassicLightReverse;
        }
        break;
      case "bestTimeClassicOriginal":
        {
          if (hasRoundFinished &&
              (bestTimeClassicOriginal == 0 ||
                  globalTimer < bestTimeClassicOriginal)) {
            bestTimeClassicOriginal = globalTimer;
          }
          tempBestTime = bestTimeClassicOriginal;
        }
        break;
      case "bestTimeClassicOriginalReverse":
        {
          if (hasRoundFinished &&
              (bestTimeClassicOriginalReverse == 0 ||
                  globalTimer < bestTimeClassicOriginalReverse)) {
            bestTimeClassicOriginalReverse = globalTimer;
          }
          tempBestTime = bestTimeClassicOriginalReverse;
        }
        break;
      case "bestTimeMemory":
        {
          if (hasRoundFinished &&
              (bestTimeMemory == 0 || globalTimer < bestTimeMemory)) {
            bestTimeMemory = globalTimer;
          }
          tempBestTime = bestTimeMemory;
        }
        break;
    }

    resultList.add("Total Time: ${globalTimer / 1000} second(s)");
    resultList.add("Best Time: ${tempBestTime / 1000} second(s)");

    if (isReverse) {
      for (int i = 0; i < MAX_ELEMENT_NUMBER; i++) {
        resultList.add("${MAX_ELEMENT_NUMBER - i}: ${list[i] / 1000}");
      }
    } else {
      for (int i = 0; i < MAX_ELEMENT_NUMBER; i++) {
        resultList.add("${i + 1}: ${list[i] / 1000}");
      }
    }

    return Flexible(
        child: Center(
            child: ListView(
                children: List.generate(
                    resultList.length,
                    (index) => Text(resultList[index],
                        textAlign: TextAlign.center)))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title: Text("$gameModeName Results"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            FlatButton(
              child: Text("Play Again!"),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () =>
                  Navigator.pushNamed(context, previousGameModeRoute),
            ),
            Container(
                child:
                    printTimeSpentToFindNumbers(this.bestTimeName, this.list))
          ],
        ),
      ),
    );
  }
}
