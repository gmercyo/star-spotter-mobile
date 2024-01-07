import 'package:flutter/material.dart';

class StyledBlockButton extends StatelessWidget {
  final Widget? child;
  // void function onPressed, can be null
  final void Function()? onPressed;
  final Color? color, disabledColor;

  const StyledBlockButton(
      {super.key, this.child, this.onPressed, this.color, this.disabledColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color ??
                    Theme.of(context).colorScheme.secondary, // background
                foregroundColor: Colors.white,
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                elevation: 1.0,
                disabledBackgroundColor: disabledColor ??
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: child,
            ),
          ),
        )
      ],
    );
  }
}
