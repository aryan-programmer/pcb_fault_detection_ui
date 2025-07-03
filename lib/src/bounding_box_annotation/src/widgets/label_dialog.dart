import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnnotationLabelDialog extends StatefulWidget {
  final String header;
  final String text;
  const AnnotationLabelDialog({
    super.key,
    required this.header,
    required this.text,
  });

  @override
  State<AnnotationLabelDialog> createState() => _AnnotationLabelDialogState();
}

class _AnnotationLabelDialogState extends State<AnnotationLabelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    setState(() {
      _controller.text = widget.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450.0),
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "${widget.header} Label",
                style: const TextStyle(
                  color: Color(0xFF38424D),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                style: const TextStyle(fontSize: 16.0),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: "Type something here",
                  hintStyle: TextStyle(
                    color: Color(0xFFA9A9A9),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Annotation Label";
                  }
                  return null;
                },
                controller: _controller,
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 5.0,
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFF747E88),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(_controller.text);
                      }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
