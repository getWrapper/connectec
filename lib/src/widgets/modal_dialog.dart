import 'package:flutter/material.dart';

class ModalDialog extends StatelessWidget {
  String title;
  String description;
  String buttonCancel;
  String buttonAction;
  VoidCallback action;
  VoidCallback actionB;

ModalDialog(this.title, String desc, String buttonCancel, String buttonAction, VoidCallback action, this.actionB){
  this.title = title;
  this.description = desc;
  this.buttonCancel = buttonCancel;
  this.buttonAction = buttonAction;
  this.action = action;
}
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                          title,
                          style: TextStyle(fontSize: 24.0, color: Colors.cyan[900]),
                          textAlign: TextAlign.center,
                        ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(description, style: TextStyle(color: Colors.cyan[900]),textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        FlatButton(
              child: new Text(buttonCancel, style: TextStyle(color: Colors.blue, fontSize: 18)),
              onPressed: actionB == null ? () {
                Navigator.of(context).pop();
              } : actionB,
            ),
                      FlatButton(
              child: new Text(buttonAction, style: TextStyle(color: Colors.blue, fontSize: 18)),
              onPressed: action,
            ),
                      ],)
                    )
                ],
              ),
            ),
          );
  }
}