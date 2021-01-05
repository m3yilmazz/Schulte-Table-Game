import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'resultPage.dart';

class MemoryModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const MemoryModePlayGround({Key key, this.parentAction}) : super(key: key);
  @override
  _MemoryModePlayGroundState createState() => _MemoryModePlayGroundState();
}

class _MemoryModePlayGroundState extends State<MemoryModePlayGround> {
  _MemoryModePlayGroundState() {
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
  bool _hasBeenPressed = false,
      _hasBeenMisclicked = true,
      initialTimerController = true,
      allButtonsLocked = true;

  @override
  Widget build(BuildContext context) {
    if (initialTimerController) {
      Timer(Duration(seconds: 3), () {
        setState(() {
          _hasBeenMisclicked = false;
          allButtonsLocked = false;
        });
      });
      initialTimerController = false;
    }

    return Visibility(
      visible: _hasBeenPressed ? false : true,
      child: Container(
        margin: EdgeInsets.all(1),
        child: FlatButton(
          child: Visibility(
            visible: _hasBeenMisclicked ? true : false,
            child: Text(this._number.toString()),
          ),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            if(!allButtonsLocked){
              if(sequenceControllerList.first == this._number) {
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
                          builder: (context) => ResultPage("bestTimeMemory", "Memory Mode", timePassedToFindNumbers, "/memoryMode", false)));
                }
              }
              else {
                setState(() {
                  _hasBeenMisclicked = true;
                });
                Timer(Duration(seconds: 3), () {
                  setState(() {
                    _hasBeenMisclicked = false;
                  });
                });
              }
            }

          },
        ),
      ),
    );
  }
}
