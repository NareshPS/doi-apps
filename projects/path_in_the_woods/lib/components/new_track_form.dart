import 'package:flutter/material.dart';

class NewTrackForm extends StatefulWidget {
  final void Function(String) onAccept;

  const NewTrackForm({
    super.key,
    required this.onAccept,
  });

  @override
  State<NewTrackForm> createState() => _NewTrackFormState();
}

class _NewTrackFormState extends State<NewTrackForm> {
  final _formKey = GlobalKey< FormState>();

  // Form field controllers
  final trackName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Start recording'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: trackName,
              decoration: const InputDecoration(
                hintText: 'Enter a name for this route'
              ),
              validator: (value) => null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onAccept(trackName.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Start')
                ),
                ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Cancel')
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}