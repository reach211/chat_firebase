import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonTitle;
  final Color colour;
  final VoidCallback onPressed;
  const RoundedButton({Key? key, required this.buttonTitle, required this.colour, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 48,
          child:Text(buttonTitle, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
