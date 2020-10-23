import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogAction {yes, abort}

class customDialog{
  static Future<DialogAction> yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
        final action = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () => Navigator.of(context).pop(DialogAction.abort),
                  child: const Text('No'),
                ),
                RaisedButton(
                  onPressed: () => Navigator.of(context).pop(DialogAction.yes),
                  child: const Text('Yes'),
                ),
              ],
            );
          }
        );
        return (action != null) ? action : DialogAction.abort;
  }
}