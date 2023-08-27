import 'package:flutter/cupertino.dart';
import 'package:voice_assistant_app/pallete.dart';

class FeatureBox extends StatelessWidget {
  FeatureBox({required this.color,required this.headerText,required this.descriptionText});

  final Color color;
  final String headerText;
  final String descriptionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0,bottom: 20,left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(headerText,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Pallete.blackColor
              ),),
            ),
            SizedBox(height: 2,),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(descriptionText),
            )
          ],
        ),
      ),
    );
  }
}
