import 'package:flutter/material.dart';

class ReceiptView extends StatelessWidget {
  final String imageURL;
  const ReceiptView({required this.imageURL,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
          icon: Icon(Icons.close), 
          onPressed: () { 
            Navigator.pop(context);
           },
          ),
        Image(
          image: NetworkImage(imageURL),
        )
        ],
      ),
    );
  }
}