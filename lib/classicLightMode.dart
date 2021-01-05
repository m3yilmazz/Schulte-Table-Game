import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'resultPage.dart';

class ClassicLightModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const ClassicLightModePlayGround({Key key, this.parentAction})
      : super(key: key);
  @override
  _ClassicLightModePlayGroundState createState() =>
      _ClassicLightModePlayGroundState();
}

class _ClassicLightModePlayGroundState
    extends State<ClassicLightModePlayGround> {
  _ClassicLightModePlayGroundState() {
    var random = new Random();
    do {
      var checkIsValidInList = random.nextInt(MAX_ELEMENT_NUMBER) + 1;
      if (listUsedForRandomAssignment.contains(checkIsValidInList)) {
        this._number = checkIsValidInList;
        listUsedForRandomAssignment.remove(checkIsValidInList);
        break;
      }
    } while (true);
  }

  int _number;
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _hasBeenPressed ? false : true,
      child: Container(
        margin: EdgeInsets.all(1),
        child: FlatButton(
          child: Text(this._number.toString()),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            if (sequenceControllerList.first == this._number) {
              var sumOfAllExistingElementsInList = 0;
              timePassedToFindNumbers.forEach((element) {
                sumOfAllExistingElementsInList += element;
              });
              timePassedToFindNumbers
                  .add(globalTimer - sumOfAllExistingElementsInList);
              sequenceControllerList.removeAt(0);
              if (this._number + 1 < MAX_ELEMENT_NUMBER + 1) {
                widget.parentAction(this._number + 1);
              }

              setState(() {
                _hasBeenPressed = !_hasBeenPressed;
              });
              if (sequenceControllerList.isEmpty) {
                hasRoundFinished = true;
                timePassedToFindNumbers.removeAt(0);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultPage(
                            "bestTimeClassicLight",
                            "Classic Light Mode",
                            timePassedToFindNumbers,
                            "/classicLightMode",
                            false)));
              }
            }
          },
        ),
      ),
    );
  }
}
