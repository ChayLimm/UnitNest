import 'package:flutter/material.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';

Future<bool> uniForm({
  required BuildContext context,
  required String title,
  required String subtitle,
  required Widget form,
  required Future<void> Function() onDone,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomDialog(
          title: title,
          subtitle: subtitle,
          form: form,
          onDone: onDone,
        ),
      ) ??
      false;
}

class CustomDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final Future<void> Function() onDone;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.onDone,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleDone() async {
   if(_formKey.currentState!.validate()){
     setState(() => _isLoading = true);
    await widget.onDone();     
    setState(() => _isLoading = false);
    Navigator.pop(context, true);
   }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SimpleDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(fontSize: 14), 
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, false); 
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
       
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: widget.form
              ),
            ),
            Container(
              width: 450,
              decoration: BoxDecoration(
                color: UniColor.backGroundColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UniButton(
                    buttonType: ButtonType.secondary,
                    context: context,
                    trigger: () => Navigator.pop(context, false),
                    label: "Cancel",
                  ),
                  const SizedBox(width: 10),
                  UniButton(
                    buttonType: ButtonType.primary,
                    context: context,
                    trigger: _handleDone,
                    label: "Done",
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
