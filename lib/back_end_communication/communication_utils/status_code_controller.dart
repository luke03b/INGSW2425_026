import 'package:domus_app/ui_elements/utils/my_pop_up_widgets.dart';
import 'package:flutter/material.dart';

class StatusCodeController {
  static controllaStatusCodeAndShowPopUp(BuildContext context, int inputStatusCode, int expectedStatusCode, String isAllOkTitle, String isAllOkText, String wrongTitle, String wrongText) async {
    if (inputStatusCode == expectedStatusCode) {
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(
          title: isAllOkTitle, 
          bodyText: isAllOkText, 
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    } else {
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (BuildContext context) => MyInfoDialog(
          title: wrongTitle, 
          bodyText: wrongText, 
          buttonText: "Ok", 
          onPressed: () {Navigator.pop(context);}
        )
      );
    }
  }
}