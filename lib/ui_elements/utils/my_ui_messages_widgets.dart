import 'package:auto_size_text/auto_size_text.dart';
import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:domus_app/ui_elements/utils/my_buttons_widgets.dart';
import 'package:domus_app/ui_elements/utils/my_loading.dart';
import 'package:flutter/material.dart';

class MyUiMessagesWidgets {
  static Center myTextWithLoading(BuildContext context, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: AutoSizeText(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: context.outline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 12,
              maxFontSize: 20,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 35),
          LoadingHelper.showLoadingDialog(context),
        ],
      ),
    );
  }

  static Center myErrorWithButton(BuildContext context, String text, String buttonText, VoidCallback onPressed) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: AutoSizeText(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: context.error,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 12,
              maxFontSize: 20,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          MyTextButtonWidget(
            text: buttonText,
            colore: context.error,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  static Center myText(BuildContext context, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: AutoSizeText(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: context.outline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 12,
              maxFontSize: 20,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static Center myTextWithButton(BuildContext context, String text, String buttonText, VoidCallback onPressed) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: AutoSizeText(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: context.outline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 12,
              maxFontSize: 20,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10,),
          MyElevatedButtonRectWidget(
            text: buttonText, 
            onPressed: () {
              onPressed();
            }, 
            color: context.tertiary
          )
        ],
      ),
    );
  }
}