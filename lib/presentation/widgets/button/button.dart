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
class UniButton extends StatefulWidget {
  final BuildContext context;
  final String label;
  final FutureOr<void> Function() trigger;
  final ButtonType buttonType;
  final Color? color;

  const UniButton({
    required this.context,
    required this.label,
    required this.trigger,
    required this.buttonType,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<UniButton> createState() => _UniButtonState();
}

class _UniButtonState extends State<UniButton> {
  bool _isDisabled = false; // State persisted across rebuilds

  void _toggleDisabled() {
    setState(() => _isDisabled = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isDisabled = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.buttonType) {
      case ButtonType.primary:
        return _buildPrimaryButton();
      case ButtonType.secondary:
        return _buildSecondaryButton();
      case ButtonType.tertiary:
        return _buildTertiaryButton();
    }
  }

  Widget _buildPrimaryButton() {
    return InkWell(
      onTap: widget.trigger,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: widget.color ?? UniColor.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: UniTextStyles.button,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return InkWell(
      onTap: widget.trigger,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: UniColor.primary, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(color: UniColor.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildTertiaryButton() {
    return InkWell(
      onTap: _isDisabled
          ? null
          : () async {
              _toggleDisabled();
              await widget.trigger(); // Wait for the action to complete
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 36,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isDisabled ? Colors.grey : UniColor.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}