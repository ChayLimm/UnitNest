import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';


class ReceiptView extends StatelessWidget {
  final String imageURL;
  const ReceiptView({required this.imageURL, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Image(
                image: NetworkImage(imageURL),
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: loading(),
                    );
                  }
                },
              ),
      ),
    );
  }
}

// Function to show the ReceiptView as a dialog
void showReceiptDialog(BuildContext context, String imageURL) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allows dismissal when tapping outside
    builder: (BuildContext context) {
      return ReceiptView(imageURL: imageURL);
    },
  );
}
