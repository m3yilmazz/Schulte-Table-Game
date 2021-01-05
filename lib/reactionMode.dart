import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'resultPage.dart';

class ReactionModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const ReactionModePlayGround({Key key, this.parentAction}) : super(key: key);
  @override
  _ReactionModePlayGroundState createState() => _ReactionModePlayGroundState();
}

class _ReactionModePlayGroundState extends State<ReactionModePlayGround> {
  _ReactionModePlayGroundState() {
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

  int _number, _controlNumber;
  bool _hasBeenPressed = false;
  @override
  Widget build(BuildContext context) {
    if (sequenceControllerList.isNotEmpty)
      _controlNumber = sequenceControllerList.first;
    else
      _controlNumber = 0;
    return Visibility(
      visible: _hasBeenPressed ? false : true,
      child: Container(
        margin: EdgeInsets.all(1),
        child: FlatButton(
          child: Visibility(
            visible: _controlNumber == this._number ? true : false,
            child: Text(this._number.toString()),
          ),
          color:
              _controlNumber == this._number ? Colors.red : Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            if (_controlNumber == this._number) {
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
                            "bestTimeReaction",
                            "Reaction Mode",
                            timePassedToFindNumbers,
                            "/reactionMode",
                            false)));
              }
            }
          },
        ),
      ),
    );
  }
}
