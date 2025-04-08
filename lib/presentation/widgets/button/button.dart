import 'dart:async';

import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';


// Step 1: Define the ButtonType enum
enum ButtonType {
  primary,
  secondary,
  tertiary, // New button type
}

// Step 2: Create a StatelessWidget class
class UniButton extends StatelessWidget {
  final BuildContext context;
  final String label;
  FutureOr<void> Function() trigger;
  final ButtonType buttonType;
  final Color? color;

  UniButton({
    required this.context,
    required this.label,
    required this.trigger,
    required this.buttonType,
    this.color,
    Key? key,
  }) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    // Step 3: Use a switch statement to handle different button types
    switch (buttonType) {
      case ButtonType.primary:
        return _buildPrimaryButton();
      case ButtonType.secondary:
        return _buildSecondaryButton();
      case ButtonType.tertiary:
        return _buildTertiaryButton(); // New case for tertiary button
    }
  }

  // Helper method to build the primary button
  Widget _buildPrimaryButton() {
    return InkWell(
      hoverColor: UniColor.white,
      splashColor: UniColor.white,
      onTap: trigger,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: color ?? UniColor.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: UniTextStyles.button,
          ),
        ),
      ),
    );
  }

  // Helper method to build the secondary button
  Widget _buildSecondaryButton() {
    return InkWell(
      hoverColor: UniColor.white,
      splashColor: UniColor.white,
      onTap: trigger,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(
            color: UniColor.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: UniColor.primary),
          ),
        ),
      ),
    );
  }

  // Helper method to build the tertiary button
  Widget _buildTertiaryButton() {
    bool isDisabled = false;

     void toggleDisabled() {
      isDisabled = true;
      Future.delayed(const Duration(seconds: 2), () {
        isDisabled = false;
      });
    }

    return InkWell(
      
      hoverColor: UniColor.white,
      splashColor: UniColor.white,
      onTap: isDisabled ? null : (){
        toggleDisabled();
        trigger();
        },
      child: SizedBox(
        height: 36,
          child: Text(
            label,
            style: TextStyle(
              color: UniColor.primary, // Text color
              decoration: TextDecoration.underline, // Optional: Add underline
            ),
          ),
      
      ),
    );
  }
}