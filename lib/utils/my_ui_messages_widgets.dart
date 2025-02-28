import 'package:domus_app/theme/ui_constants.dart';
import 'package:domus_app/utils/my_buttons_widgets.dart';
import 'package:domus_app/utils/my_loading.dart';
import 'package:flutter/material.dart';

class MyUiMessagesWidgets {
  static Column myTextWithLoading(BuildContext context, String text){
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height/5,),
        Text(text, style: TextStyle(color: context.outline),),
        SizedBox(height: MediaQuery.of(context).size.height/35,),
        LoadingHelper.showLoadingDialog(context),
      ],
    );
  }

  static Column myErrorWithButton(BuildContext context, String text, String buttonText, VoidCallback onPressed) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height/5,),
        Text(text, style: TextStyle(color: context.error, fontSize: 20),),
        MyTextButtonWidget(text: buttonText, 
          colore: context.error, 
          onPressed: (){
            onPressed();
          },
        ),
      ],
    );
  }

  static Column myText(BuildContext context, String text){
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height/5,),
        Text(text, style: TextStyle(color: context.onSecondary, fontSize: 18),),
      ],
    );
  }
}